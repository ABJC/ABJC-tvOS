//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 27.11.21.
//

import SwiftUI

@main
struct ABJCApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
