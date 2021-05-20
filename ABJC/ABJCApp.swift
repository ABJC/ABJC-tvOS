//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI
import URLImage

@main
struct ABJCApp: App {
    /// Session Store
    let session: SessionStore = SessionStore()
    
    func configure() {
        // Configure URLImageService
        URLImageService.shared.defaultOptions.cachePolicy = .returnCacheElseLoad(cacheDelay: 0.0, downloadDelay: 0.25)
        URLImageService.shared.defaultOptions.loadOptions = [ .loadImmediately, .cancelOnDisappear]
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(session)
                .onAppear(perform: configure)
        }
    }
}
