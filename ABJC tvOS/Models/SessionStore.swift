//
//  SessionStore.swift
//  SessionStore
//
//  Created by Noah Kamara on 09.09.21.
//

import Foundation
import JellyfinAPI
import SwiftUI

class SessionStore: ObservableObject {
    @Environment(\.appConfiguration) var app
    
    static let shared: SessionStore = .init()
    static let debug: SessionStore = .init(debug: true)
    
    @Published var isAuthenticated: Bool = false
    @Published var credentials: Jellyfin.Credentials?

    var wrappedCredentials: Jellyfin.Credentials {
        if let credentials = self.credentials {
            return credentials
        } else {
            fatalError("No Credentials")
        }
    }
    func setServerURI(_ uri: String) {
        JellyfinAPI.basePath = uri
        print("BASEURL", JellyfinAPI.basePath)
    }
    
    func generateHeaders() {
        let deviceID = Jellyfin.Credentials._deviceId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceName = UIDevice.current.name
        
        var embyAuthorization = [
            "Emby Client=\"ABJC tvOS\"",
            "Device=\"\(deviceName)\"",
            "DeviceId=\"\(deviceID)\"",
            "Version=\"\(appVersion ?? "0.0.1")\"",
        ]
        
        if let credentials = credentials {
            // Add Token
            embyAuthorization.append("Token=\"\(credentials.accessToken)\"")
        }
        
        JellyfinAPI.customHeaders["X-Emby-Authorization"] = embyAuthorization.joined(separator: ",")
    }
    
    func didAuthenticate(_ result: AuthenticationResult) {
        self.credentials = .init(result)
        self.generateHeaders()
        self.isAuthenticated = true
        self.objectWillChange.send()
    }
    
    init(debug: Bool = false) {
        #if DEBUG
//        let deviceId = "tvOS_\(UIDevice.current.identifierForVendor!.uuidString)"
//        let accessToken = "1a3b30119b2948d78cc35669faa242a9"
//        let baseURI = "http://192.168.178.35:8096"
//        self.credentials = Jellyfin.Credentials(userId: "aeed0c89a1864e7bb318100083099634")
//        self.setServerURI(baseURI)
//        self.generateHeaders(userToken: accessToken, deviceID: deviceId)
//        self.isAuthenticated = true
        
        // Reset PreferenceStore
        PreferenceStore.reset()
        #endif
        
        if PreferenceStore.shared.isFirstBoot {
            app.analytics.send(.installed, with: [:])
        }
        
        if PreferenceStore.shared.wasUpdated {
            app.analytics.send(.updated, with: [:])
        }
    }
}
