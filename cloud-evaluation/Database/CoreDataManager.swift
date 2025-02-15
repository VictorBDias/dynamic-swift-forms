//
//  CoreDataManager.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "FormDatabase")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    /// **Load JSON and Save to Core Data**
    func loadFormsIfNeeded() {
        let request: NSFetchRequest<FormEntity> = FormEntity.fetchRequest()
        
        do {
            let existingForms = try context.fetch(request)
            if existingForms.isEmpty {
                print("No forms found. Loading from JSON...")
                loadForms(from: "200-form.json")
                loadForms(from: "all-fields.json")
            } else {
                print("Forms already exist in Core Data. Count: \(existingForms.count)")
            }
        } catch {
            print("Error checking existing forms: \(error)")
        }
    }

    func resetPersistentStore() {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        do {
            try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(
                at: storeURL, ofType: NSSQLiteStoreType, options: nil
            )
            try persistentContainer.persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil
            )
            print("✅ Core Data Reset Successfully")
        } catch {
            print("❌ Error resetting Core Data: \(error)")
        }
    }

    private func loadForms(from filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Error: File \(filename) not found.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let form = try decoder.decode(FormModel.self, from: data)
            saveForm(form)
            print("Successfully loaded \(form.title) from \(filename)")
        } catch {
            print("Error loading JSON \(filename): \(error)")
        }
    }

    /// **Convert FormModel into Core Data**
    private func saveForm(_ form: FormModel) {
        let formEntity = FormEntity(context: context)
        formEntity.title = form.title

        for field in form.fields {
            let fieldEntity = FieldEntity(context: context)
            fieldEntity.type = field.normalizedType
            fieldEntity.label = field.label
            fieldEntity.name = field.name
            fieldEntity.required = field.required ?? false
            fieldEntity.uuid = field.uuid
            fieldEntity.form = formEntity
        }

        if let sections = form.sections {
            for section in sections {
                let sectionEntity = SectionEntity(context: context)
                sectionEntity.title = section.title
                sectionEntity.from = Int64(section.from)
                sectionEntity.to = Int64(section.to)
                sectionEntity.index = Int64(section.index)
                sectionEntity.uuid = section.uuid
                sectionEntity.form = formEntity
            }
        }

        saveContext()
    }
}
