//
//  ContentView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FormEntity.timestamp, ascending: true)],
        animation: .default)
    private var forms: FetchedResults<FormEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(forms) { form in
                    NavigationLink(destination: FormDetailView(form: form)) {
                        VStack(alignment: .leading) {
                            Text(form.title ?? "Untitled Form")
                                .font(.headline)
                            if let timestamp = form.timestamp {
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
            newForm.timestamp = Date() // Ensure timestamp exists in FormEntity

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
    ContentView().environment(\.managedObjectContext, CoreDataManager.shared.context)
}
