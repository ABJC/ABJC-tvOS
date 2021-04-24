//
//  SessionStore.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation
import SwiftUI
import os

class SessionStore: ObservableObject {
    /// Logger
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SESSION")
        
    /// Jellyfin Object
    @Published public var jellyfin: Jellyfin? = nil
    
    /// Preference Store
    @Published public var preferences: PreferenceStore = PreferenceStore()
    
    /// Focus Item
    @Published public var itemFocus: APIModels.MediaItem? = nil
    
    /// Playing Item
    @Published public var itemPlaying: APIModels.MediaItem? = nil
    
    /// Pending Alert
    @Published var alert: Alert? = nil
    
    /// Cached Items
    @Published var items: [APIModels.MediaItem] = []
    
    public func loadCredentials(_ completion: @escaping (Bool) -> Void = { _ in}) {
        guard let data = Keychain.load(key: "credentials") else {
            completion(false)
            return
        }
        do {
            let jellyfin = try JSONDecoder().decode(Jellyfin.self, from: data)
            API.currentUser(jellyfin) { (result) in
                switch result {
                    case .success(_ ):
                        self.logger.info("[CREDENTIALS] successfully authenticated with stored credentials")
                        self.setJellyfin(jellyfin)
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
    
    public func clearCredentials() {
        Keychain.clear(key: "credentials")
    }
    
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
    
    public func setFocus(_ item: APIModels.MediaItem) {
        DispatchQueue.main.async {
            self.itemFocus = item
        }
    }
    
    public func setPlayItem(_ item: APIModels.MediaItem) {
        self.itemPlaying = item
    }
    
    
    /// Set Jellyfin Object
    /// - Parameter jellyfin: Jellyfin Object
    public func setJellyfin(_ jellyfin: Jellyfin) {
        DispatchQueue.main.async {
            self.jellyfin = jellyfin
            self.storeCredentials()
        }
    }
    public func logout() {
        self.clearCredentials()
        DispatchQueue.main.async {
            self.jellyfin = nil
        }
    }
    
    
    /// Set Alert
    /// - Parameters:
    ///   - alertType: <#alertType description#>
    ///   - localized: <#localized description#>
    ///   - debug: <#debug description#>
    ///   - error: <#error description#>
    public func setAlert(_ alertType: Alert.AlertType, _ localized: String, _ debug: String, _ error: Error?) {
        logger.warning("[\(alertType.rawValue)], \(debug), \(error != nil ? error!.localizedDescription : "NO ERROR")")
        DispatchQueue.main.async {
            self.alert = Alert(title: alertType.localized, description: LocalizedStringKey("alerts." + alertType.rawValue + "." + localized))
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
        var title: LocalizedStringKey
        var description: LocalizedStringKey
        
        enum AlertType: String {
            case auth = "auth"
            case api = "api"
            case playback = "playback"
            
            var logInfo: String {
                return self.rawValue.uppercased()
            }
            
            var localized: LocalizedStringKey {
                return LocalizedStringKey("alerts.\(self.rawValue).title")
            }
        }
    }
}
