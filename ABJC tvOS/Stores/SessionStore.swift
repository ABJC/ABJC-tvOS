/*
 ABJC - tvOS
 SessionStore.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import CoreData
import Foundation
import JellyfinAPI
import SwiftUI
import TVServices

class SessionStore: ObservableObject {
    @Environment(\.appConfiguration) var app

    let logger: Logger = .shared

    static let shared: SessionStore = .init()
    static let debug: SessionStore = .init(debug: true)

    let viewContext = PersistenceController.shared.container.viewContext

    @Published var isAuthenticated: Bool = false

    @Published var user: UserCredentials?

    @Published var tvUserId: String? = nil

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

        if let user = user,
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

    func switchUser() {
        logger.log.info("Switching User \(user?.name ?? "no user")")
        isAuthenticated = false

        user = nil
    }

    func removeUser() {
        logger.log.info("Removing User \(user?.name ?? "no user") from persistence")
        isAuthenticated = false

        do {
            if let user = user {
                viewContext.delete(user)
                try viewContext.save()
                self.user = nil
                objectWillChange.send()
            }
        } catch {
            fatalError("Failed to log out user '\(error)'")
        }
    }

    init(debug _: Bool = false) {
        #if DEBUG
            if CommandLineArguments.shouldReset {
                PreferenceStore.shared.reset()
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserCredentials.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try PersistenceController.shared.container.viewContext.execute(deleteRequest)
                } catch {
                    fatalError("Failed to Reset PersistenceContainer")
                }
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
                            newUserCred.appletvId = self.tvUserId
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

        let tvUserManager = TVUserManager()
        tvUserId = tvUserManager.currentUserIdentifier
        let usersFetchRequest: NSFetchRequest<UserCredentials> = UserCredentials.fetchRequest()
        let users = try? PersistenceController.shared.container.viewContext.fetch(usersFetchRequest)

        users?.forEach { user in
            if user.appletvId == tvUserId {
                logger.log.info("Authenticating TVUser with persisted credentials", tag: "SessionStore")
                self.setServerURI(user.serverURI ?? "")
                self.didAuthenticate(user)
            }
        }

        if PreferenceStore.shared.isFirstBoot {
            app.analytics.send(.installed, with: [:])
            PreferenceStore.shared.isFirstBoot = false
        }

        if PreferenceStore.shared.wasUpdated {
            app.analytics.send(.updated, with: [:])
        }
    }
}
