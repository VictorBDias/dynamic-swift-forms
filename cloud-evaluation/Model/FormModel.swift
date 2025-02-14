//
//  Form.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import Foundation

struct FormModel: Codable {
    let title: String
    let fields: [FormField]
    let sections: [FormSection]?
}
