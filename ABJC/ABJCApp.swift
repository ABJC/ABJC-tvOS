//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI
import URLImage
import NewRelic

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NewRelic.disableFeatures([
            .NRFeatureFlag_ExperimentalNetworkingInstrumentation,
            .NRFeatureFlag_HttpResponseBodyCapture,
            .NRFeatureFlag_NetworkRequestEvents
        ])
        NewRelic.start(withApplicationToken:"eu01xx3ffb20a4549b937ac5fe2e2c5b8f4f49c9b3-NRMA")
        return true
    }
}

@main
struct ABJCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Session Store
    let session: SessionStore = SessionStore()
    
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
