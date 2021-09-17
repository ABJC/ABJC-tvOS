//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI
import URLImage
import Firebase

@main
struct ABJCApp: App {
    init() {
        FirebaseApp.configure()
        self.session = SessionStore()
    }
    
    /// Session Store
    let session: SessionStore
    
    var urlImageOptions: URLImageOptions {
        var options = URLImageOptions()
        //        options.fetchPolicy = .returnStoreElseLoad(downloadDelay: 0.25)
        options.loadOptions = [ .loadImmediately ]
        return options
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(session)
                .environment(\.urlImageOptions, urlImageOptions)
                .environment(\.urlImageService, URLImageService())
        }
    }
}
