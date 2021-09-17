//
//  AuthenticationViewModel.swift
//  AuthenticationViewModel
//
//  Created by Noah Kamara on 09.09.21.
//

import AnyCodable
import Combine
import Foundation
import JellyfinAPI

class AuthenticationViewDelegate: ViewDelegate {
    let analyticsMetadata: [String: AnyEncodable] = [
        "view": .init(ViewIdentifier.auth)
    ]
    @Published
    var isConnected: Bool = false
    
    // Discovery of Servers
    private let discovery = ServerDiscovery()
    
    @Published
    var discoveredServers: [ServerDiscovery.ServerLookupResponse] = []
    @Published
    var isDiscoveringServers: Bool = false
    
    // Manual Server Entry
    @Published
    var willEnterServerManually: Bool = false
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
    @Published
    var willEnterUserManually: Bool = false
    //    #if DEBUG
    //    @Published var username: String = "jellyfin"
    //    @Published var password: String = "password"
    //    #else
    @Published
    var username: String = ""
    @Published
    var password: String = ""
    //    #endif
    
    /// Discover Servers in local network
    func lookupServers() {
        isDiscoveringServers = true
        
        // Timeout after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isDiscoveringServers = false
        }
        
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
        UserAPI.getPublicUsers { result in
            switch result {
                case let .success(response):
                    self.publicUsers = response
                    self.isConnected = true
                case let .failure(error):
                    self.alert = .init(.cantConnectToHost)
                    self.handleApiError(error, with: self.analyticsMetadata)
            }
        }
    }
    
    func authenticate(username: String, password: String? = nil) {
        session.generateHeaders()
        let body = AuthenticateUserByName(username: username, pw: password)
        
        UserAPI.authenticateUserByName(authenticateUserByName: body) { result in
            switch result {
                case let .success(result):
                    self.session.didAuthenticate(result)
                case let .failure(error):
                    self.alert = .init(.authenticationFailed)
                    self.handleApiError(error, with: self.analyticsMetadata)
            }
        }
    }
}
