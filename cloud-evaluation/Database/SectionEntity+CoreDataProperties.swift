//
//  SectionEntity+CoreDataProperties.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//
//

import Foundation
import CoreData


extension SectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionEntity> {
        return NSFetchRequest<SectionEntity>(entityName: "SectionEntity")
    }

    @NSManaged public var from: Int64
    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var to: Int64
    @NSManaged public var uuid: String?
    @NSManaged public var form: FormEntity?

}

extension SectionEntity : Identifiable {

}
