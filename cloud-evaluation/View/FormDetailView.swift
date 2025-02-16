//
//  CoreDataManager.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//


import SwiftUI
import WebKit

struct FormDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let formEntry: FormEntryEntity
    let form: FormEntity
    @State private var formData: [String: String] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) { // Align all content to the leading edge
                ForEach(form.sectionsArray, id: \.uuid) { section in
                    Section(header: VStack(alignment: .leading) {
                        WebView(html: section.title ?? "Section")
                            .frame(height: 100)
                    }) {
                        let sectionFields = form.fieldsArray.filter { field in
                            guard let fieldIndex = form.fieldsArray.firstIndex(where: { $0.uuid == field.uuid }) else {
                                return false
                            }
                            return fieldIndex >= section.from && fieldIndex <= section.to
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
        .onAppear(perform: loadExistingData)
        .navigationBarBackButtonHidden(true)
    }

    /// Dynamically Render Form Fields Based on Type
    @ViewBuilder
    private func getFieldView(for field: FieldEntity) -> some View {
        switch field.type {
        case "number":
            VStack(alignment: .leading) { // Align content to the leading edge
                Text(field.label ?? "Label")
                    .foregroundColor(.gray)

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
            }

        case "dropdown":
            VStack(alignment: .leading) { // Align content to the leading edge
                Text(field.label ?? "Label")
                    .foregroundColor(.gray)

                if !field.optionsArray.isEmpty {
                    let defaultSelection = formData[field.uuid ?? ""] ?? field.optionsArray.first?.value ?? ""

                    HStack {
                        Picker(selection: Binding(
                            get: { formData[field.uuid ?? ""] ?? defaultSelection },
                            set: { formData[field.uuid ?? ""] = $0 }
                        ), label: EmptyView()) {
                            ForEach(field.optionsArray, id: \.value) { option in
                                Text(option.label)
                                    .tag(option.value)
                                    .padding(.vertical, 10)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(height: 50)
                        .cornerRadius(5)

                        Spacer()
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                } else {
                    Text("No options available")
                        .foregroundColor(.red)
                }
            }

        case "description":
            VStack(alignment: .leading) { // Align content to the leading edge
                WebView(html: field.label ?? "Description")
                    .frame(height: 40)

                TextField("Fill the field", text: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
                .foregroundColor(.gray)
            }

        default:
            VStack(alignment: .leading) { // Align content to the leading edge
                Text(field.label ?? "Label")
                    .foregroundColor(.gray)

                TextField("Enter \(field.label ?? "text")", text: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
                .foregroundColor(.gray)
            }
        }
    }

    /// Load existing data from Core Data
    private func loadExistingData() {
        if let savedData = formEntry.data,
           let decodedData = try? JSONDecoder().decode([String: String].self, from: savedData) {
            formData = decodedData
        } else {
            formData = [:]
        }
    }

    /// Save user input to Core Data
    private func saveEntry() {
        if let encodedData = try? JSONEncoder().encode(formData) {
            formEntry.data = encodedData
            try? viewContext.save()
        }
    }
}
