//
//  FieldEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//
//

import Foundation
import CoreData


extension FieldEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FieldEntity> {
        return NSFetchRequest<FieldEntity>(entityName: "FieldEntity")
    }

    @NSManaged public var label: String?
    @NSManaged public var name: String?
    @NSManaged public var required: Bool
    @NSManaged public var type: String?
    @NSManaged public var uuid: String?
    @NSManaged public var form: FormEntity?

}

extension FieldEntity : Identifiable {

}
