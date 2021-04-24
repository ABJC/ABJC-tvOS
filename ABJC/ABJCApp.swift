//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

@main
struct ABJCApp: App {
    /// Session Store
    let session: SessionStore = SessionStore()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(session)
        }
    }
}
