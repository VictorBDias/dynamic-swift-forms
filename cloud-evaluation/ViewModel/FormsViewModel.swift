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
        let request: NSFetchRequest<FormEntity> = FormEntity.fetchRequest()
        do {
            forms = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching forms: \(error)")
        }
    }
}
