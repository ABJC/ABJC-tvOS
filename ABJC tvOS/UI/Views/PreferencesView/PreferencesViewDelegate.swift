/*
 ABJC - tvOS
 PreferencesViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import Foundation
import JellyfinAPI

class PreferencesViewDelegate: ViewDelegate {
    // Preference Temporary Store
    @Published
    var showsTitles: Bool = true
    @Published
    var collectionGrouping: CollectionGrouping = .default
    @Published
    var posterType: PreferenceStore.PosterType = .default
    @Published
    var betaflags = Set<PreferenceStore.BetaFlag>()

    //    @Published var alwaysShowTitles: Bool = true
    //    @Published var alwaysShowTitles: Bool = true
    //    @Published var alwaysShowTitles: Bool = true

    @Published
    var serverConfiguration: ServerConfiguration?
    @Published
    var systemInfo: SystemInfo?
    @Published
    var itemCounts: ItemCounts?

    func onAppear() {
        loadPreferences()
    }

    func onDisappear() {
        savePreferences()
        app.analytics.send(.preferences(preferences))
    }

    func loadPreferences() {
        collectionGrouping = preferences.collectionGrouping
        showsTitles = preferences.showsTitles
        posterType = preferences.posterType
    }

    func savePreferences() {
        preferences.showsTitles = showsTitles
        preferences.posterType = posterType
        preferences.collectionGrouping = collectionGrouping
        preferences.objectWillChange.send()
    }

    /// Fetch Server Configuration
    func loadServerConfiguration() {
        ConfigurationAPI.getConfiguration { result in
            switch result {
                case let .success(response): self.serverConfiguration = response
                case let .failure(error): print(error)
            }
        }
    }

    /// Fetch System Info from API
    func loadSystemInfo() {
        SystemAPI.getSystemInfo { result in
            switch result {
                case let .success(response): self.systemInfo = response
                case let .failure(error): print(error)
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
                case let .success(response): self.itemCounts = response
                case let .failure(error): print(error)
            }
        }
    }
}
