/*
 ABJC - tvOS
 DetailViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import Foundation
import JellyfinAPI

class DetailViewDelegate: ViewDelegate {
    let playerStore: PlayerViewDelegate

    @Published
    var isPlaying: Bool = false

    public let item: BaseItemDto

    @Published
    var imageUrl: URL?

    @Published
    var itemSimilars: [BaseItemDto] = []
    //    @Published var actors: [BaseItemPerson] = []
    //    @Published var studio: String?
    //    @Published var director: String?
    //    @Published var itemPeople: [Person] = []

    // Loads imageUrl
    func loadImageUrl() {
        guard let itemId = item.id else {
            return
        }
        let imageType: ImageType = preferences.posterType == .poster ? .primary : .backdrop
        ImageAPI.getItemImage(itemId: itemId, imageType: imageType) { result in
            switch result {
                case let .success(url): self.imageUrl = url
                case let .failure(error):
                    self.handleApiError(error)
            }
        }
    }

    // Load similar items
    func loadItemsSimilar() {
        guard let userId = session.credentials?.userId, let itemId = item.id else {
            return
        }
        LibraryAPI.getSimilarItems(
            itemId: itemId,
            excludeArtistIds: nil,
            userId: userId,
            limit: nil,
            fields: [.genres, .overview, .people]
        ) { result in
            switch result {
                case let .success(response):
                    self.itemSimilars = response.items ?? []
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }

    func onAppear() {
        loadImageUrl()
        loadItemsSimilar()
    }

    func play() {
        print("PLAYING")
        playerStore.initPlayback()
        isPlaying = true
        objectWillChange.send()
    }

    init(_ item: BaseItemDto) {
        self.item = item
        playerStore = .init(item)
    }
}
