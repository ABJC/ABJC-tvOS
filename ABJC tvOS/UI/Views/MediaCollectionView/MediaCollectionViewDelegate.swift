/*
 ABJC - tvOS
 MediaCollectionViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 21.09.21
 */

import JellyfinAPI
import SwiftUI

class MediaCollectionViewDelegate: ViewDelegate {
    @Published
    var items: [BaseItemDto] = []

    func loadItems(for types: [ItemType]) {
        logger.log.info("loading items for (\(types.map(\.rawValue).joined(separator: ",")))", tag: "MediaCollectionView")
        ItemsAPI.getItems(
            userId: session.credentials!.userId,
            recursive: true,
            fields: [.genres, .overview, .people],
            includeItemTypes: types.map(\.rawValue)
        ) { result in
            switch result {
                case let .success(result): self.items = result.items ?? []
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }
}
