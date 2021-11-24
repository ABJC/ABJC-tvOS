/*
 ABJC - tvOS
 SearchViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

class SearchViewDelegate: ViewDelegate {
    @Published var searchTerm: String = ""
    @Published var searchResults: [BaseItemDto] = []
    @Published var searchHints: [SearchHint] = []

    func retrieveSearchHints(_ searchTerm: String) {
        guard let userId = session.user?.id else {
            return
        }

        SearchAPI.callGet(
            searchTerm: searchTerm,
            userId: userId,
            includeItemTypes: [ItemType.movie, ItemType.series].map(\.rawValue),
            includePeople: true,
            includeMedia: true,
            includeGenres: true,
            includeStudios: true,
            includeArtists: true
        ) { result in
            switch result {
                case let .success(searchHint):
                    self.searchHints = searchHint.searchHints ?? []
                case let .failure(error):
                    self.handleApiError(error)
            }
        }
    }

    func performSearch() {
        print("SEARCHING")
        guard let userId = session.user?.id else {
            return
        }

        ItemsAPI.getItems(
            userId: userId,
            recursive: true,
            searchTerm: searchTerm,
            fields: [.genres, .overview, .people],
            includeItemTypes: [ItemType.series, ItemType.movie].map(\.rawValue)
        ) { result in
            switch result {
                case let .success(result):
                    self.searchResults = result.items ?? []
                    print(self.searchResults.count)
                    self.objectWillChange.send()
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }
}
