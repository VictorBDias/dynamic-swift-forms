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
}
