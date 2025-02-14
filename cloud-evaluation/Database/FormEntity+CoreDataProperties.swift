//
//  FormEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
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
    @NSManaged public var fields: FieldEntity?
    @NSManaged public var sections: SectionEntity?

}

extension FormEntity : Identifiable {

}
