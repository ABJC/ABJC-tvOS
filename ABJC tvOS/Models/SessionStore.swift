/*
 * ABJC is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Noah Kamara &amp; ABJC Contributors
 */

import Foundation
import JellyfinAPI
import SwiftUI

class SessionStore: ObservableObject {
    @Environment(\.appConfiguration)
    var app
    
    static let shared: SessionStore = .init()
    static let debug: SessionStore = .init(debug: true)
    
    @Published
    var isAuthenticated: Bool = false
    @Published
    var credentials: Jellyfin.Credentials?
    
    var wrappedCredentials: Jellyfin.Credentials {
        if let credentials = self.credentials {
            return credentials
        } else {
            fatalError("No Credentials")
        }
    }
    
    func setServerURI(_ uri: String) {
        JellyfinAPI.basePath = uri
        //        print("BASEURL", JellyfinAPI.basePath)
    }
    
    func generateHeaders() {
        let deviceID = Jellyfin.Credentials.staticDeviceId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceName = UIDevice.current.name
        
        var embyAuthorization = [
            "Emby Client=\"ABJC tvOS\"",
            "Device=\"\(deviceName)\"",
            "DeviceId=\"\(deviceID)\"",
            "Version=\"\(appVersion ?? "0.0.1")\""
        ]
        
        if let credentials = credentials {
            // Add Token
            embyAuthorization.append("Token=\"\(credentials.accessToken)\"")
        }
        
        JellyfinAPI.customHeaders["X-Emby-Authorization"] = embyAuthorization.joined(separator: ",")
    }
    
    func didAuthenticate(_ result: AuthenticationResult) {
        credentials = .init(result)
        generateHeaders()
        isAuthenticated = true
        objectWillChange.send()
    }
    
    init(debug _: Bool = false) {
#if DEBUG
        app.analytics.send(.appError(.with(["message": "URL Couldn't be generated"])))
        if CommandLineArguments.shouldReset {
            PreferenceStore.shared.reset()
        }
        
        CommandLineArguments.shouldAuthenticate { username in
            let constants = Constants.current!
            
            self.setServerURI(constants.serverURI)
            self.generateHeaders()
            
            let userCredentials = constants.users[username]!
            let body = AuthenticateUserByName(username: userCredentials.username, pw: userCredentials.password)
            UserAPI.authenticateUserByName(authenticateUserByName: body) { result in
                switch result {
                    case let .failure(error):
                        print(error)
                        fatalError("Couldn't Authenticate")
                    case let .success(response): self.didAuthenticate(response)
                }
            }
        }
#endif
        
        if PreferenceStore.shared.isFirstBoot {
            app.analytics.send(.installed, with: [:])
            PreferenceStore.shared.isFirstBoot = false
        }
        
        if PreferenceStore.shared.wasUpdated {
            app.analytics.send(.updated, with: [:])
        }
    }
}
