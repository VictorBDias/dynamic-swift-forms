import SwiftUI
import WebKit

struct FormDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let formEntry: FormEntryEntity
    let form: FormEntity
    @State private var formData: [String: String] = [:] // Store user input

    var body: some View {
        Form {
            ForEach(form.fieldsArray, id: \.uuid) { field in
                Section(header: Text(field.label ?? "Field")) {
                    getFieldView(for: field)
                }
            }
        }
        .navigationTitle("Fill Form Entry")
        .toolbar {
            Button("Save", action: saveEntry)
        }
        .onAppear(perform: loadExistingData)
    }


    /// Dynamically Render Form Fields Based on Type
    @ViewBuilder
    private func getFieldView(for field: FieldEntity) -> some View {
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
            }

        case "checkbox":
            Toggle(isOn: Binding(
                get: { formData[field.uuid ?? ""] == "true" },
                set: { formData[field.uuid ?? ""] = $0 ? "true" : "false" }
            )) {
                Text(field.label ?? "Checkbox")
            }

        case "radio":
            if !field.optionsArray.isEmpty {
                Picker(selection: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ), label: Text(field.label ?? "Radio")) {
                    ForEach(field.optionsArray, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            } else {
                Text("No options available")
                    .foregroundColor(.red)
            }

        case "dropdown":
            if !field.optionsArray.isEmpty {
                Picker(selection: Binding(
                    get: { formData[field.uuid ?? ""] ?? "" },
                    set: { formData[field.uuid ?? ""] = $0 }
                ), label: Text(field.label ?? "Dropdown")) {
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
            WebView(html: field.label ?? "Description")
                .frame(height: 100)

        default:
            TextField(field.label ?? "Field", text: Binding(
                get: { formData[field.uuid ?? ""] ?? "" },
                set: { formData[field.uuid ?? ""] = $0 }
            ))
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

