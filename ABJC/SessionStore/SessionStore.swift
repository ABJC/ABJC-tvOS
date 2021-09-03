//
//  SessionStore.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation
import SwiftUI
import os
import AnalyticsClient

class SessionStore: ObservableObject {
    static let variables: Constants = .load
    /// Logger
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SESSION")
    
    public let analytics: AnalyticsManager = .testflight(url: variables.analytics_url, apikey: variables.analytics_key)

        
    /// Jellyfin Object
    @Published public var jellyfin: Jellyfin? = nil
    
    @Published public var loggedIn: Bool = false
    
    /// Preference Store
    @Published public var preferences: PreferenceStore = PreferenceStore()
    
    /// Focus Item
    @Published public var itemFocus: APIModels.MediaItem? = nil
    
    /// Playing Item
    @Published public var itemPlaying: PlayItem? = nil
    
    /// Pending Alert
    @Published var alert: Alert? = nil
    
    /// Cached Items
    @Published var items: [APIModels.MediaItem] = []
    
    
    /// Loads Credentials and tries to authenticate with them
    /// - Parameter completion: Boolean value indicating success
    public func loadCredentials(_ completion: @escaping (Bool) -> Void = { _ in}) {
        guard let data = Keychain.load(key: "credentials") else {
            completion(false)
            return
        }
        do {
            let jellyfin = try JSONDecoder().decode(Jellyfin.self, from: data)
            
            // If credentials don't store a User, UserSelectView will appear
            if !jellyfin.isUserLoggedIn()
            {
                self.logger.info("[CREDENTIALS] successfully authenticated server with stored credentials")
                self.setJellyfin(jellyfin, false)
                completion(true)
                return
            }
            
            API.currentUser(jellyfin) { (result) in
                switch result {
                    case .success(_ ):
                        self.logger.info("[CREDENTIALS] successfully authenticated with stored credentials")
                        self.setJellyfin(jellyfin, true)
                        completion(true)
                        
                    case .failure(let error):
                        self.logger.info("[CREDENTIALS] failed to authenticate with stored credentials")
                        self.setAlert(
                            .auth,
                            "failed",
                            "\(jellyfin.server.https ? "(HTTPS)":"") \(jellyfin.user.userId)@\(jellyfin.server.host):\(jellyfin.server.port)",
                            error
                        )
                        completion(false)
                }
            }
        } catch {
            print(error)
            self.logger.info("[CREDENTIALS] unable to load credentials")
            completion(false)
        }
    }
    
    
    /// Clears Stored Credentials
    public func clearCredentials() {
        Keychain.clear(key: "credentials")
    }
    
    
    /// Stores Credentials in Keychain
    public func storeCredentials() {
        do {
            let data = try JSONEncoder().encode(self.jellyfin)
            _ = Keychain.save(key: "credentials", data: data)
            self.logger.info("[CREDENTIALS] successfully stored credentials")
        } catch {
            print(error)
            self.logger.info("[CREDENTIALS] failed to store credentials")
        }
    }
    
    
    /// Sets the focus of the application
    /// - Parameter item: Media Item (Movie, Series)
    public func setFocus(_ item: APIModels.MediaItem) {
        DispatchQueue.main.async {
            self.itemFocus = item
        }
    }
    
    
    /// Sets play item
    /// - Parameter item: Playable Media Item
    public func setPlayItem(_ item: PlayItem) {
        self.itemPlaying = item
        print(self.itemPlaying!.name)
//        DispatchQueue.main.async {
//            self.prevFocus = self.itemFocus
//            self.itemPlaying = item
//            self.itemFocus = nil
//        }
    }
    
    
    /// Set Jellyfin Object
    /// - Parameter jellyfin: Jellyfin Object
    /// - Parameter logIn: If true session.loggedIn will be set to true
    public func setJellyfin(_ jellyfin: Jellyfin, _ logIn: Bool) {
        DispatchQueue.main.async {
            self.jellyfin = jellyfin
            self.loggedIn = logIn ? true : self.loggedIn
            self.storeCredentials()
        }
    }
    
    
    /// Remove the user from the stored credentials and set loggedIn to false
    public func logout() {
        // Remove User from the saved credentials
        // Keeps the Server saved
        DispatchQueue.main.async { [self] in
            loggedIn = false
            jellyfin?.resetUser()
            storeCredentials()
        }
    }
    
    /// Remove the server from the stored credentials
    public func removeServer() {
        DispatchQueue.main.async { [self] in
            loggedIn = false
            clearCredentials()
            jellyfin = nil
        }
    }
    
    
    /// Set Alert
    /// - Parameters:
    ///   - alertType: Alert Type
    ///   - localized: Localized Description
    ///   - debug: Debug Description
    ///   - error: error description
    public func setAlert(_ alertType: Alert.AlertType, _ localized: String?, _ debug: String, _ error: Error?) {
        logger.warning("[\(alertType.rawValue)], \(debug), \(error != nil ? error!.localizedDescription : "NO ERROR")")
        DispatchQueue.main.async { [self] in
            if let localized = localized {
                if preferences.isDebugEnabled {
                    self.alert = Alert(title: alertType.localized, description: debug)
                } else {
                    self.alert = Alert(title: alertType.localized, description: "alerts." + alertType.rawValue + "." + localized + ".label")
                }
                
            } else {
                self.alert = Alert(title: alertType.localized, description: debug)
            }
        }
    }
    
    /// Reload Items / Refetch from API
    public func reloadItems() {
        guard let jellyfin = jellyfin else { return }
        
        API.items(jellyfin) { result in
            switch result {
                case .success(let items):
                    DispatchQueue.main.async {
                        self.items.append(contentsOf: items.filter({ !self.items.contains($0) }))
                    }
                case .failure(let error):
                    self.setAlert(.api, "Could not fetch Data from Server", "API.items failed", error)
            }
        }
    }
}

extension SessionStore {
    struct Alert: Identifiable {
        var id: String = Date().description
        var title: String
        var description: String
        
        enum AlertType: String {
            case info = "info"
            case auth = "auth"
            case api = "api"
            case playback = "playback"
            
            var logInfo: String {
                return self.rawValue.uppercased()
            }
            
            var localized: String {
                return "alerts.\(self.rawValue).title"
            }
        }
    }
}
