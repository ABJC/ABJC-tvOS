/*
 ABJC - tvOS
 LibraryViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

class LibraryViewDelegate: ViewDelegate {
    func updateCoverArt() {
        guard let userId = session.user?.id else {
            return
        }

        Task(priority: .userInitiated) {
            let fetchRequest = MatchedCoverArt.fetchRequest()
            var existingCoverArt: [String] = []
            do {
                let results = try session.viewContext.fetch(fetchRequest)
                existingCoverArt = results.compactMap(\.itemId)
            } catch {
                print("Error loading Persistence", error)
            }

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
                      !existingCoverArt.contains(itemId),
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
            session.objectWillChange.send()
        }
    }
}
