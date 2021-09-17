//
//  MediaCollectionViewDelegate.swift
//  MediaCollectionViewDelegate
//
//  Created by Noah Kamara on 09.09.21.
//

import JellyfinAPI
import SwiftUI

class MediaCollectionViewDelegate: ViewDelegate {
    @Published
    var items: [BaseItemDto] = []

    func loadItems(for types: [ItemType]) {
        ItemsAPI.getItems(userId: session.credentials!.userId,
                          recursive: true,
                          fields: [.genres, .overview, .people],
                          includeItemTypes: types.map(\.rawValue)) { result in
            switch result {
            case let .success(result): self.items = result.items ?? []
            case let .failure(error):
                self.alert = .init(.failedToLoadItems)
                self.handleApiError(error)
            }
        }
    }
}
