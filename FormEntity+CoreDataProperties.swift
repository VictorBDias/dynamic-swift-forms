//
//  FormEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//
//

import Foundation
import CoreData


extension FormEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormEntity> {
        return NSFetchRequest<FormEntity>(entityName: "FormEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var fields: NSSet?
    @NSManaged public var sections: NSSet?

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

extension FormEntity : Identifiable {

}
