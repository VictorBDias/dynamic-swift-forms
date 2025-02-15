//
//  FormEntriesViewModel.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import Foundation
import CoreData
import SwiftUI

class FormEntriesViewModel: ObservableObject {
    @Published var entries: [FormEntryEntity] = []

    func fetchEntries(for form: FormEntity) {
        let request: NSFetchRequest<FormEntryEntity> = FormEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "form == %@", form)

        do {
            entries = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching entries: \(error)")
        }
    }

    func addEntry(for form: FormEntity) {
        let newEntry = FormEntryEntity(context: CoreDataManager.shared.context)
        newEntry.uuid = UUID().uuidString
        newEntry.timestamp = Date()
        newEntry.form = form

        CoreDataManager.shared.saveContext()
        fetchEntries(for: form)
    }

    func deleteEntry(at offsets: IndexSet, form: FormEntity) {
        withAnimation {
            offsets.map { entries[$0] }.forEach(CoreDataManager.shared.context.delete)
            do {
                try CoreDataManager.shared.context.save()
                fetchEntries(for: form) // Refresh list
            } catch {
                print("Error deleting entry: \(error)")
            }
        }
    }
}
