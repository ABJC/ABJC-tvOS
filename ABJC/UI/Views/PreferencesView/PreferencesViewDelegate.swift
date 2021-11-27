/*
 ABJC - tvOS
 PreferencesViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import Foundation
import JellyfinAPI
import SwiftUI

class PreferencesViewDelegate: ViewDelegate {
    // Preference Temporary Store
    @Published var showsTitles: Bool = true
    @Published var collectionGrouping: CollectionGrouping = .default
    @Published var posterType: PreferenceStore.PosterType = .default
    @Published var betaflags = Set<PreferenceStore.BetaFlag>()

    @Published var isDebugEnabled: Bool = false

    //    @Published var alwaysShowTitles: Bool = true
    //    @Published var alwaysShowTitles: Bool = true
    //    @Published var alwaysShowTitles: Bool = true

    @Published var serverConfiguration: ServerConfiguration?
    @Published var systemInfo: SystemInfo?
    @Published var itemCounts: ItemCounts?

    @Published var matchedCoverArt: [MatchedCoverArt] = []

    func onAppear() {
        loadPreferences()
    }

    func onDisappear() {
        savePreferences()
    }

    func loadPreferences() {
        logger.log.info("loading preferences", tag: "PreferencesView")
        collectionGrouping = preferences.collectionGrouping
        showsTitles = preferences.showsTitles
        posterType = preferences.posterType
        isDebugEnabled = preferences.isDebugEnabled
    }

    func savePreferences() {
        logger.log.info("saving preferences", tag: "PreferencesView")
        let diffs = [
            preferences.showsTitles != showsTitles,
            preferences.posterType != posterType,
            preferences.collectionGrouping != collectionGrouping,
            preferences.isDebugEnabled != isDebugEnabled
        ]

        preferences.showsTitles = showsTitles
        preferences.posterType = posterType
        preferences.collectionGrouping = collectionGrouping
        preferences.isDebugEnabled = isDebugEnabled
        preferences.objectWillChange.send()

        if diffs.contains(true) {
            app.analytics.send(.preferences(preferences))
        }
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

    /// Remove User from persistence
    func removeUser() {
        session.removeUser()
    }

    /// Remove User from persistence
    func switchUser() {
        session.switchUser()
    }

    /// Fetch System Info from API
    func loadSystemInfo() {
        logger.log.info("loading system info", tag: "PreferencesView")
        SystemAPI.getSystemInfo { result in
            switch result {
                case let .success(response): self.systemInfo = response
                case let .failure(error):
                    self.handleApiError(error)
            }
        }
    }

    /// Fetch Item Counts from API
    func loadItemCounts() {
        logger.log.info("loading item counts", tag: "PreferencesView")

        guard let userId = session.user?.id else {
            print("No UserID")
            return
        }
        LibraryAPI.getItemCounts(userId: userId) { result in
            switch result {
                case let .success(response): self.itemCounts = response
                case let .failure(error): self.handleApiError(error)
            }
        }
    }

    func checkForArt() {
        let fetchRequest = MatchedCoverArt.fetchRequest()

        do {
            let results = try session.viewContext.fetch(fetchRequest)
            matchedCoverArt = results
        } catch {
            print("Error loading Persistence", error)
        }
        objectWillChange.send()
    }

    func updateArt() {
        guard let userId = session.user?.id else {
            return
        }

        Task(priority: .userInitiated) {
            let result = await withCheckedContinuation { continuation in
                ItemsAPI.getItems(
                    userId: userId,
                    recursive: true,
                    fields: [],
                    includeItemTypes: [ItemType.movie, ItemType.series].map(\.rawValue)
                ) { result in
                    continuation.resume(returning: result)
                }
            }

            var items: [BaseItemDto] = []
            switch result {
                case let .success(result): items = result.items ?? []
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }

            print(items.map(\.name))

            for item in items {
                guard let itemId = item.id,
                      let match = await CoverArtMatcher.match(item: item),
                      match.success else {
                    continue
                }

                let newMatch = MatchedCoverArt(context: session.viewContext)
                newMatch.itemId = item.id
                newMatch.coverArt = match.item?.coverArt.coverArt
                newMatch.logo = match.item?.coverArt.logo

                do {
                    try session.viewContext.save()
                } catch {
                    print(error)
                }
            }

            self.checkForArt()
        }
    }
}
