//
//  PreferencesViewDelegate.swift
//  PreferencesViewDelegate
//
//  Created by Noah Kamara on 10.09.21.
//

import Foundation
import JellyfinAPI

class PreferencesViewDelegate: ViewDelegate {
    
    
    // Preference Temporary Store
    @Published var showsTitles: Bool = true
    @Published var collectionGrouping: CollectionGrouping = .default
    @Published var posterType: PreferenceStore.PosterType = .default
    @Published var betaflags: Set<PreferenceStore.BetaFlag> = Set<PreferenceStore.BetaFlag>()
    
//    @Published var alwaysShowTitles: Bool = true
//    @Published var alwaysShowTitles: Bool = true
//    @Published var alwaysShowTitles: Bool = true
    
    @Published var serverConfiguration: ServerConfiguration? = nil
    @Published var systemInfo: SystemInfo? = nil
    @Published var itemCounts: ItemCounts? = nil
    
    
    func onAppear() {
        loadPreferences()
    }
    
    func onDisappear() {
        savePreferences()
    }
    
    func loadPreferences() {
        self.collectionGrouping = preferences.collectionGrouping
        self.showsTitles = preferences.showsTitles
        self.posterType = preferences.posterType
    }
    
    func savePreferences() {
        preferences.showsTitles = self.showsTitles
        preferences.posterType = self.posterType
        preferences.collectionGrouping = self.collectionGrouping
        self.preferences.objectWillChange.send()
    }
    
    /// Fetch Server Configuration
    func loadServerConfiguration() {
        ConfigurationAPI.getConfiguration { result in
            switch result {
                case .success(let response): self.serverConfiguration = response
                case .failure(let error): print(error)
            }
        }
    }
    
    /// Fetch System Info from API
    func loadSystemInfo() {
        SystemAPI.getSystemInfo { result in
            switch result {
                case .success(let response): self.systemInfo = response
                case .failure(let error): print(error)
            }
        }
    }
    
    /// Fetch Item Counts from API
    func loadItemCounts() {
        guard let userId = session.credentials?.userId else {
            print("No UserID")
            return
        }
        LibraryAPI.getItemCounts(userId: userId) { result in
            switch result {
                case .success(let response): self.itemCounts = response
                case .failure(let error): print(error)
            }
        }
    }
    
    
    
}
