//
//  FormEntriesView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import SwiftUI
import CoreData

struct FormEntriesView: View {
    let formEntry: FormEntryEntity

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FormEntryEntity.timestamp, ascending: true)],
        animation: .default)
    private var formEntries: FetchedResults<FormEntryEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(formEntries) { entry in
                    NavigationLink(destination: FormDetailView(formE: entry)) {
                        VStack(alignment: .leading) {
                            Text(entry.description ?? "Untitled Form")
                                .font(.headline)
                            if let timestamp = entry.timestamp {
                                Text(timestamp, formatter: itemFormatter)
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteForms(offsets: IndexSet) {
        withAnimation {
            offsets.map { forms[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    FormView().environment(\.managedObjectContext, CoreDataManager.shared.context)
}
