//
//  Persistence.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let sampleForm = FormEntity(context: viewContext)
        sampleForm.title = "Sample Form"
        sampleForm.timestamp = Date()

        let sampleField = FieldEntity(context: viewContext)
        sampleField.label = "Sample Field"
        sampleField.name = "sample_field"
        sampleField.type = "text"
        sampleField.required = true
        sampleField.uuid = UUID().uuidString
        sampleField.form = sampleForm

        let sampleSection = SectionEntity(context: viewContext)
        sampleSection.title = "Sample Section"
        sampleSection.index = 0
        sampleSection.from = 0
        sampleSection.to = 10
        sampleSection.uuid = UUID().uuidString
        sampleSection.form = sampleForm

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FormDatabase") // Ensure this matches your Core Data model name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
