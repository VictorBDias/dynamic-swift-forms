//
//  FormEntriesView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import SwiftUI
import CoreData

struct FormEntriesView: View {
    let form: FormEntity

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FormEntryEntity.timestamp, ascending: true)],
        animation: .default)
    private var formEntries: FetchedResults<FormEntryEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(formEntries.indices, id: \.self) { index in
                    let entry = formEntries[index]
                    NavigationLink(destination: FormView()) {
                        VStack(alignment: .leading) {
                            Text("Entry ID: \(entry.uuid ?? "Unknown")")
                                .font(.headline)
                            if let date = entry.timestamp {
                                Text("Created: \(date, formatter: dateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteForms)
            }
            .navigationTitle("Forms")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addForm) {
                        Label("Add Form", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addForm() {
        withAnimation {
            let newForm = FormEntity(context: viewContext)
            newForm.title = "New Form"
            newForm.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    private func deleteForms(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let entry = formEntries[index]
                viewContext.delete(entry)
            }
            do {
                try viewContext.save()
            } catch {
                print("Error deleting entry: \(error)")
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}
