//
//  CoreDataManager.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import SwiftUI
import WebKit
import Combine

struct FormDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    let formEntry: FormEntryEntity
    let form: FormEntity
    @State private var formData: [String: String] = [:]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var autoSaveTimer: Timer.TimerPublisher = Timer.publish(every: 5, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?

    @State private var isNavigatingBack = false

    private var entryId: String { formEntry.uuid ?? "unknown_form" }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(form.sectionsArray, id: \.uuid) { section in
                    Section(header: VStack(alignment: .leading) {
                        WebView(html: section.title ?? "Section")
                            .frame(height: 140)
                    }) {
                        let sectionFields = form.fieldsArray.sorted {
                            ($0.value(forKey: "index") as? Int64 ?? 0) < ($1.value(forKey: "index") as? Int64 ?? 0)
                        }.filter { field in
                            field.index >= section.from && field.index <= section.to
                        }

                        ForEach(sectionFields, id: \.uuid) { field in
                            getFieldView(for: field)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Fill Form Entry")
                    .font(.system(size: 16, weight: .semibold))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: saveEntry)
            }

        }
        .onAppear(perform: {
            loadExistingData()
            self.timerCancellable = autoSaveTimer.connect()
        })
        .onDisappear {
            if isNavigatingBack {
                LocalStorageManager.shared.clearFormProgress(for: entryId)
                print("✅ Cleared form progress on manual navigation back")
            }
            self.timerCancellable?.cancel()
        }
        .onReceive(autoSaveTimer) { _ in
            autoSaveProgress()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("⚠️ Missing Required Fields"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    /// Save progress periodically
    private func autoSaveProgress() {
        LocalStorageManager.shared.saveFormProgress(for: entryId, data: formData)
        print("✅ Auto-saved progress for \(entryId)")
    }

    /// Dynamically Render Form Fields Based on Type
    @ViewBuilder
    private func getFieldView(for field: FieldEntity) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if field.type != "description" {
                    Text(field.label ?? "Label")
                        .foregroundColor(.gray)
                    if field.required {
                        Text("*")
                            .foregroundColor(.red)
                    }
                }
            }

            switch field.type {
            case "number":
                Stepper(
                    value: Binding(
                        get: { Int(formData[field.uuid ?? ""] ?? "0") ?? 0 },
                        set: { formData[field.uuid ?? ""] = String($0) }
                    ),
                    in: 0...100
                ) {
                    Text("\(formData[field.uuid ?? ""] ?? "0")")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }

            case "dropdown":
                if !field.optionsArray.isEmpty {
                    let defaultSelection = formData[field.uuid ?? ""] ?? field.optionsArray.first?.value ?? ""
                    Picker(selection: Binding(
                        get: { formData[field.uuid ?? ""] ?? defaultSelection },
                        set: { formData[field.uuid ?? ""] = $0 }
                    ), label: Text("Select")) {
                        ForEach(field.optionsArray, id: \.value) { option in
                            Text(option.label).tag(option.value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                } else {
                    Text("No options available").foregroundColor(.red)
                }

            case "description":
                WebView(html: field.label ?? "Description")
                    .frame(height: 40)
                    .padding(.vertical, 8)

                TextField("Fill the field", text: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)

            default:
                TextField("Enter \(field.label ?? "text")", text: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
        }
    }

    /// Load existing data from Core Data
    private func loadExistingData() {
        if let savedData = LocalStorageManager.shared.getSavedFormProgress(for: formEntry.uuid ?? "") {
            formData = savedData
            print("Loaded saved progress from LocalStorageManager")
        }
        else if let savedData = formEntry.data,
                let decodedData = try? JSONDecoder().decode([String: String].self, from: savedData) {
            formData = decodedData
            print("Loaded saved progress from Core Data")
        }
        else {
            formData = [:]
            print("No saved progress found. Starting with a new form.")
        }
    }

    /// Save user input to Core Data
    private func saveEntry() {
        let renderedFields = form.sectionsArray.flatMap { section in
            form.fieldsArray.filter { $0.index >= section.from && $0.index <= section.to }
        }
        
        let missingRequiredFields = renderedFields.filter { field in
            field.required && (formData[field.uuid ?? ""]?.isEmpty ?? true)
        }
        
        if !missingRequiredFields.isEmpty {
            _ = missingRequiredFields.map { $0.label ?? "Unknown Field" }.joined(separator: ", ")
            alertMessage = "Please fill in all the required fields"
            showAlert = true
            return
        }

        if let encodedData = try? JSONEncoder().encode(formData) {
            formEntry.data = encodedData
            try? viewContext.save()
        }
        
        LocalStorageManager.shared.clearFormProgress(for: entryId)

        presentationMode.wrappedValue.dismiss()
    }
}
