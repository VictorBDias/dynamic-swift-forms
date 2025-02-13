//
//  FormField.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import Foundation

struct FormField: Codable {
    let type: String
    let label: String
    let name: String
    let required: Bool?
    let uuid: String
    let options: [FieldOption]? 
    
    var normalizedType: String {
        let supportedTypes = ["description", "dropdown", "text", "number"]
        return supportedTypes.contains(type) ? type : "text"
    }
}
