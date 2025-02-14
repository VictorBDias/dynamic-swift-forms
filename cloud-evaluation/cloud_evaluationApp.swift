//
//  cloud_evaluationApp.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import SwiftUI
import CoreData
import Foundation

@main
struct cloud_evaluationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
