//
//  cloud_evaluationApp.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 13/02/25.
//

import SwiftUI

@main
struct cloud_evaluationApp: App {
    let coreDataManager = CoreDataManager.shared

    init() {
        CoreDataManager.shared.loadFormsIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.context) 
        }
    }
}
