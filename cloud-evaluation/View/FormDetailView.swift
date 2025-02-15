////
////  FormDetailView.swift
////  cloud-evaluation
////
////  Created by Victor Batisttete Dias on 14/02/25.
////
//import SwiftUI
//
//struct FormDetailView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    let formEntry: FormEntryEntity
//    let form: FormEntity
//    @State private var formData: [String: String] = [:] // Store user input
//
//    var body: some View {
//        Form {
//            ForEach(form.fieldsArray, id: \.uuid) { field in
//                Section(header: Text(field.label ?? "Field")) {
//                    getFieldView(for: field)
//                }
//            }
//        }
//        .navigationTitle("Fill Form Entry")
//        .toolbar {
//            Button("Save", action: saveEntry)
//        }
//        .onAppear(perform: loadExistingData)
//    }
//
//    @ViewBuilder
//    private func getFieldView(for field: FieldEntity) -> some View {
//        if field.type == "text" || field.type == "number" {
//            TextField(field.label ?? "Field", text: Binding(
//                get: { formData[field.uuid ?? ""] ?? "" },
//                set: { formData[field.uuid ?? ""] = $0 }
//            ))
//            .keyboardType(field.type == "number" ? .numberPad : .default)
//        } else if field.type == "dropdown", !field.optionsArray.isEmpty {
//            Picker(field.label ?? "Field", selection: Binding(
//                get: { formData[field.uuid ?? ""] ?? "" },
//                set: { formData[field.uuid ?? ""] = $0 }
//            )) {
//                ForEach(field.optionsArray, id: \.value) { option in
//                    Text(option.label).tag(option.value)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//        } else if field.type == "description" {
//            Text(field.label ?? "Description")
//                .foregroundColor(.gray)
//        } else {
//            TextField(field.label ?? "Field", text: Binding(
//                get: { formData[field.uuid ?? ""] ?? "" },
//                set: { formData[field.uuid ?? ""] = $0 }
//            ))
//        }
//    }
//
//    private func loadExistingData() {
//        if let savedData = formEntry.data,
//           let decodedData = try? JSONDecoder().decode([String: String].self, from: savedData) {
//            formData = decodedData
//        }
//    }
//
//    private func saveEntry() {
//        if let encodedData = try? JSONEncoder().encode(formData) {
//            formEntry.data = encodedData
//            try? viewContext.save()
//        }
//    }
//}
//
