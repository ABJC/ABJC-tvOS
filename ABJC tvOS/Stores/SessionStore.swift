/*
 ABJC - tvOS
 SessionStore.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 05.10.21
 */

import Foundation
import JellyfinAPI
import SwiftUI

class SessionStore: ObservableObject {
    @Environment(\.appConfiguration)
    var app

    let logger: Logger = .shared

    static let shared: SessionStore = .init()
    static let debug: SessionStore = .init(debug: true)

    let viewContext = PersistenceController.shared.container.viewContext

    @Published
    var isAuthenticated: Bool = false
    @Published
    var credentials: Jellyfin.Credentials?

    @Published
    var user: UserCredentials?

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
        let deviceID = user?.deviceId ?? Jellyfin.Credentials.staticDeviceId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceName = UIDevice.current.name

        logger.log.info(
            "generateHeaders: deviceID='\(deviceID)', appVersion='\(appVersion ?? "ERR")', deviceName='\(String(repeating: "*", count: deviceName.count))'",
            tag: "SessionStore"
        )

        var embyAuthorization = [
            "Emby Client=\"ABJC tvOS\"",
            "Device=\"\(deviceName)\"",
            "DeviceId=\"\(deviceID)\"",
            "Version=\"\(appVersion ?? "0.0.1")\""
        ]

        if let user = self.user,
           let token = user.token {
            // Add Token
            embyAuthorization.append("Token=\"\(token)\"")
        }

        JellyfinAPI.customHeaders["X-Emby-Authorization"] = embyAuthorization.joined(separator: ",")
    }

    func didAuthenticate(_ user: UserCredentials) {
        self.user = user
        generateHeaders()
        isAuthenticated = true
        objectWillChange.send()

        logger.log.info("didAuthenticate \(user.id ?? "No USERID")", tag: "SessionStore")
    }

    init(debug _: Bool = false) {
        #if DEBUG
            if CommandLineArguments.shouldReset {
                PreferenceStore.shared.reset()
            }

            if CommandLineArguments.isDebugEnabled {
                PreferenceStore.shared.isDebugEnabled = true
            }

            CommandLineArguments.shouldAuthenticate { username in
                let constants = Constants.current!

                self.setServerURI(constants.serverURI)
                self.generateHeaders()

                let userCredentials = constants.users[username]!
                let body = AuthenticateUserByName(username: userCredentials.username, pw: userCredentials.password)
                UserAPI.authenticateUserByName(authenticateUserByName: body) { result in

                    switch result {
                        case let .success(result):
                            let newUserCred = UserCredentials(context: self.viewContext)
                            newUserCred.id = result.user?.id
                            newUserCred.token = result.accessToken
                            newUserCred.name = result.user?.name
                            newUserCred.serverName = result.user?.serverName
                            newUserCred.serverURI = JellyfinAPI.basePath
                            newUserCred.imageTag = result.user?.primaryImageTag

                            do {
                                try self.viewContext.save()
                            } catch {
                                print("Failed to save UserCredential")
                            }

                            self.didAuthenticate(newUserCred)
                        case let .failure(error):
                            fatalError("Couldn't Authenticate: \(error)")
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
