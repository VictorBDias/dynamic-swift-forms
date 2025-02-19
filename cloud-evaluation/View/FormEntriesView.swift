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

    @FetchRequest private var formEntries: FetchedResults<FormEntryEntity>

    @State private var newEntry: FormEntryEntity?
    @State private var isNavigating = false

    init(form: FormEntity) {
        let request: NSFetchRequest<FormEntryEntity> = FormEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "form == %@", form)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FormEntryEntity.timestamp, ascending: true)]
        
        _formEntries = FetchRequest(fetchRequest: request)
        self.form = form
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(formEntries, id: \.uuid) { entry in
                        NavigationLink(value: entry) {
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
                    .onDelete(perform: deleteEntries)
                }

                Button(action: addEntry) {
                    Label("Add Entry", systemImage: "plus")
                }
                .padding()
            }
            .navigationTitle("Entries for \(form.title ?? "Form")")
            .navigationDestination(for: FormEntryEntity.self) { entry in
                FormDetailView(formEntry: entry, form: form)
            }
            .navigationDestination(isPresented: $isNavigating) {
                if let newEntry = newEntry {
                    FormDetailView(formEntry: newEntry, form: form)
                }
            }
        }
    }

    private func addEntry() {
        let entry = FormEntryEntity(context: viewContext)
        entry.uuid = UUID().uuidString
        entry.timestamp = Date()
        entry.form = form
                
        do {
            try viewContext.save()
            newEntry = entry
            isNavigating = true
        } catch {
            print("❌ Error saving new entry: \(error)")
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let entry = formEntries[index]
                viewContext.delete(entry)
            }
            do {
                try viewContext.save()
            } catch {
                print("❌ Error deleting entry: \(error)")
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
