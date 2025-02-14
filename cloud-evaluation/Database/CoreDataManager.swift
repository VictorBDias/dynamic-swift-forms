//
//  CoreDataManager.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//


import CoreData
import UIKit

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

    func saveForm(_ form: Form) {
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

        for section in form.sections {
            let sectionEntity = SectionEntity(context: context)
            sectionEntity.title = section.title
            sectionEntity.from = Int64(section.from)
            sectionEntity.to = Int64(section.to)
            sectionEntity.index = Int64(section.index)
            sectionEntity.uuid = section.uuid
            sectionEntity.form = formEntity
        }

        saveContext()
    }
}
