//
//  FormDetailViewModel.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//


import Foundation
import CoreData

class FormDetailViewModel: ObservableObject {
    @Published var fields: [FieldEntity] = []

    func loadFormFields(for form: FormEntity) {
        if let fieldsArray = form.fields?.allObjects as? [FieldEntity] {
            self.fields = fieldsArray
        }
    }
}
