//
//  cloud_evaluationApp.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import SwiftUI
import CoreData

@main
struct cloud_evaluationApp: App {
    let coreDataManager = CoreDataManager.shared
    @State private var pendingFormID: String?

    init() {
        CoreDataManager.shared.loadFormsIfNeeded()
        checkForPendingForms()
    }

    var body: some Scene {
        WindowGroup {
            let context = coreDataManager.context
            if let formID = pendingFormID, let form = fetchFormByID(formID) {
                FormEntriesView(form: form)
                    .environment(\.managedObjectContext, context)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, context) 
            }
        }
    }

    /// Check if user has any unsaved forms
    private func checkForPendingForms() {
        let allForms = CoreDataManager.shared.context.fetchAllForms()
        for form in allForms {
            if LocalStorageManager.shared.hasSavedProgress(for: form.title ?? "") {
                pendingFormID = form.title
                break
            }
        }
    }

    /// Fetch form entity by title
    private func fetchFormByID(_ formID: String) -> FormEntity? {
        let request: NSFetchRequest<FormEntity> = FormEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", formID)

        do {
            return try CoreDataManager.shared.context.fetch(request).first
        } catch {
            print("Error fetching form with ID \(formID): \(error)")
            return nil
        }
    }
}
