//
//  FormEntryEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//
//

import Foundation
import CoreData


extension FormEntryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormEntryEntity> {
        return NSFetchRequest<FormEntryEntity>(entityName: "FormEntryEntity")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var data: Data?
    @NSManaged public var form: FormEntity?

}

extension FormEntryEntity : Identifiable {

}
