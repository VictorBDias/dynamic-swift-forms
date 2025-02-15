//
//  FormEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//
//

import Foundation
import CoreData


extension FormEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormEntity> {
        return NSFetchRequest<FormEntity>(entityName: "FormEntity")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var fields: NSSet?
    @NSManaged public var sections: NSSet?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for fields
extension FormEntity {

    @objc(addFieldsObject:)
    @NSManaged public func addToFields(_ value: FieldEntity)

    @objc(removeFieldsObject:)
    @NSManaged public func removeFromFields(_ value: FieldEntity)

    @objc(addFields:)
    @NSManaged public func addToFields(_ values: NSSet)

    @objc(removeFields:)
    @NSManaged public func removeFromFields(_ values: NSSet)

}

// MARK: Generated accessors for sections
extension FormEntity {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: SectionEntity)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: SectionEntity)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}

// MARK: Generated accessors for entries
extension FormEntity {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: FormEntryEntity)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: FormEntryEntity)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension FormEntity : Identifiable {
    var fieldsArray: [FieldEntity] {
        (fields as? Set<FieldEntity>)?.sorted { $0.label ?? "" < $1.label ?? "" } ?? []
    }
    
    var sectionsArray: [SectionEntity] {
        (sections as? Set<SectionEntity>)?.sorted { $0.index < $1.index } ?? []
    }
}

