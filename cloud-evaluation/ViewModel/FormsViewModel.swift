//
//  FormsViewModel.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import Foundation
import CoreData

class FormsViewModel: ObservableObject {
    @Published var forms: [FormEntity] = []

    func fetchForms() {
        let request = NSFetchRequest<FormEntity>(entityName: "FormEntity")
        
        do {
            forms = try CoreDataManager.shared.context.fetch(request)
            if forms.isEmpty {
                print("No forms found in Core Data.")
            } else {
                print("Loaded \(forms.count) forms from Core Data.")
            }
        } catch let error as NSError {
            print("Core Data fetch error: \(error.localizedDescription), \(error.userInfo)")
        }
    }
}
