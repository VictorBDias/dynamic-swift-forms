//
//  FormDetailView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//
import SwiftUI

struct FormDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let formEntry: FormEntryEntity
    let form: FormEntity
    @State private var formData: [String: String] = [:] // Store user input

    var body: some View {
        Form {
            ForEach(form.fieldsArray, id: \.uuid) { field in
                Section(header: Text(renderHTML(field.label ?? "Field"))) {
                    getFieldView(for: field)
                        .onAppear { // ✅ Debugging field type
                            print("Rendering field type:", field.type ?? "Unknown")
                        }
                }
            }
        }
        .navigationTitle("Fill Form Entry")
        .toolbar {
            Button("Save", action: saveEntry)
        }
        .onAppear(perform: loadExistingData)
    }

    /// **Dynamically Render Form Fields Based on Type**
    @ViewBuilder
    private func getFieldView(for field: FieldEntity) -> some View {
        switch field.type {
        case "text":
            TextField((try? AttributedString(markdown: field.label ?? "Field").description) ?? field.label ?? "Field", text: Binding(
                get: { formData[field.uuid ?? ""] ?? "" },
                set: { formData[field.uuid ?? ""] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())

        case "number":
            Stepper(
                value: Binding(
                    get: { Int(formData[field.uuid ?? ""] ?? "0") ?? 0 },
                    set: { formData[field.uuid ?? ""] = String($0) }
                ),
                in: 0...100 // Define the number range as needed
            ) {
                Text("\(formData[field.uuid ?? ""] ?? "0")")
            }

        case "checkbox":
            Toggle(isOn: Binding(
                get: { formData[field.uuid ?? ""] == "true" },
                set: { formData[field.uuid ?? ""] = $0 ? "true" : "false" }
            )) {
                Text(renderHTML(field.label ?? "Checkbox"))
            }

        case "radio":
            if !field.optionsArray.isEmpty {
                Picker(selection: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ), label: Text(renderHTML(field.label ?? "Radio"))) {
                    ForEach(field.optionsArray, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Radio button style
            } else {
                Text("No options available")
                    .foregroundColor(.red)
            }

        case "dropdown":
            if !field.optionsArray.isEmpty {
                Picker(selection: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ), label: Text(renderHTML(field.label ?? "Dropdown"))) {
                    ForEach(field.optionsArray, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            } else {
                Text("No options available")
                    .foregroundColor(.red)
            }

        case "description":
            Text(renderHTML(field.label ?? "Description"))
                .foregroundColor(.gray)

        default:
            TextField((try? AttributedString(markdown: field.label ?? "Field").description) ?? field.label ?? "Field", text: Binding(
                get: { formData[field.uuid ?? ""] ?? "" },
                set: { formData[field.uuid ?? ""] = $0 }
            ))
        }
    }

    /// **Convert HTML to AttributedString for Display**
    private func renderHTML(_ html: String) -> String {
        return (try? AttributedString(markdown: html).description) ?? html
    }

    /// **Load existing data from Core Data**
    private func loadExistingData() {
        if let savedData = formEntry.data,
           let decodedData = try? JSONDecoder().decode([String: String].self, from: savedData) {
            formData = decodedData
        }
    }

    /// **Save user input to Core Data**
    private func saveEntry() {
        if let encodedData = try? JSONEncoder().encode(formData) {
            formEntry.data = encodedData
            try? viewContext.save()
        }
    }
}
