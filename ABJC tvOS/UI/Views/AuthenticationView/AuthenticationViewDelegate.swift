/*
 ABJC - tvOS
 AuthenticationViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import AnyCodable
import Combine
import Foundation
import JellyfinAPI
import SwiftUI

class AuthenticationViewDelegate: ViewDelegate {
    var analyticsMetadata: [String: AnyEncodable] {
        [
            "view": .init(ViewIdentifier.auth),
            "state": .init(viewState.rawValue)
        ]
    }

    @Published
    var viewState: ViewState = .initial

    // Persistence
    @Published
    var persistedUsers: [UserCredentials] = []

    // Server Discoverd
    // Discovery of Servers
    private let discovery = ServerDiscovery()
    @Published
    var isDiscoveringServers: Bool = true
    @Published
    var discoveredServers: [ServerDiscovery.ServerLookupResponse] = []

    // Server Manual Entry:
    @Published
    var manualHost: String = ""
    @Published
    var manualPort: String = "8096"
    @Published
    var manualPath: String = ""
    @Published
    var manualHttps: Bool = false

    // User Selection
    @Published
    var publicUsers: [UserDto] = []

    // Manual User Entry
    @Published
    var username: String = ""
    @Published
    var password: String = ""

    func exitButtonPressed() {
        switch viewState {
            case .initial,
                 .persistence:
                #warning("Don't use in production")
                exit(0)
            case .serverSelection:
                if persistedUsers.count > 0 {
                    viewState = .persistence
                } else {
                    #warning("Don't use in production")
                    exit(0)
                }
            case .serverManual:
                viewState = .serverSelection
            case .userSelection:
                viewState = .serverSelection
            case .userManual:
                viewState = .userSelection
        }
    }

    func checkForPersistence() {
        let fetchRequest = UserCredentials.fetchRequest()

        do {
            let results = try session.viewContext.fetch(fetchRequest)
            persistedUsers = results

            if results.count > 0 {
                viewState = .persistence
            } else {
                viewState = .serverSelection
            }

        } catch {
            print("Error loading Persistence", error)
        }
    }

    /// Discover Servers in local network
    func lookupServers() {
        isDiscoveringServers = true

        // Timeout after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isDiscoveringServers = false
        }

        logger.log.info("locating servers", tag: "AuthenticationView")

        discovery.locateServer { [self] server in
            if let server = server, !discoveredServers.contains(server) {
                discoveredServers.append(server)
            }
            isDiscoveringServers = false
        }
    }

    /// Set Server in Session
    /// - Parameter uri: Server baseURI
    func setServer(to uri: String) {
        session.setServerURI(uri)
        loadPublicUsers()
    }

    /// Manually set server
    func setServerManual() {
        var urlComps = URLComponents()
        urlComps.scheme = manualHttps ? "https" : "http"
        urlComps.host = manualHost
        urlComps.port = Int(manualPort)
        var path: String = ""
        if !manualPath.isEmpty {
            path = manualPath
            // Ensure users have not entered a '/'
            if path.contains("/") {
                path.removeFirst()
            }
        }
        urlComps.path = manualPath

        guard let url = urlComps.url else {
            session.app.analytics.send(.appError(.with(["message": "URL Couldn't be generated"])))
            fatalError("Failed to construct URL")
        }
        setServer(to: url.absoluteString)
    }

    /// Load Public Users
    func loadPublicUsers() {
        logger.log.info("loading public users", tag: "AuthenticationView")
        UserAPI.getPublicUsers { result in
            switch result {
                case let .success(response):
                    self.publicUsers = response
                    self.viewState = .userSelection
                case let .failure(error):
                    self.alert = .init(.cantConnectToHost)
                    self.handleApiError(error, with: self.analyticsMetadata)
            }
        }
    }

    func authenticate(_ creds: UserCredentials) {
        logger.log.info("authenticating user", tag: "AuthenticationView")
        setServer(to: creds.serverURI ?? "")
        session.didAuthenticate(creds)
    }

    func authenticate(username: String, password: String? = nil) {
        logger.log.info("authenticating user", tag: "AuthenticationView")
        session.generateHeaders()
        let body = AuthenticateUserByName(username: username, pw: password)

        UserAPI.authenticateUserByName(authenticateUserByName: body) { result in
            switch result {
                case let .success(result):
                    let newUserCred = UserCredentials(context: self.session.viewContext)
                    newUserCred.id = result.user?.id
                    newUserCred.token = result.accessToken
                    newUserCred.name = result.user?.name
                    newUserCred.serverName = result.user?.serverName
                    newUserCred.serverURI = JellyfinAPI.basePath
                    newUserCred.imageTag = result.user?.primaryImageTag
                    newUserCred.appletvId = self.session.tvUserId

                    do {
                        try self.session.viewContext.save()
                    } catch {
                        print("Failed to save UserCredential")
                    }

                    self.session.didAuthenticate(newUserCred)
                case let .failure(error):
                    self.alert = .init(.authenticationFailed)
                    self.handleApiError(error, with: self.analyticsMetadata)
            }
        }
    }
}

extension AuthenticationViewDelegate {
    enum ViewState: String {
        case initial
        case serverSelection
        case serverManual
        case userSelection
        case userManual
        case persistence

        var localized: LocalizedStringKey {
            switch self {
                case .initial:
                    return ""
                case .serverSelection:
                    return "Select your Server"
                case .serverManual:
                    return "Enter Server"
                case .userSelection,
                     .userManual:
                    return "Who's watching?"
                case .persistence:
                    return "Welcome Back!"
            }
        }
    }
}
