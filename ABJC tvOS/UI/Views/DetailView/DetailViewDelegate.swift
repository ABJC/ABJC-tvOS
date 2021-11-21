/*
 ABJC - tvOS
 DetailViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 20.11.21
 */

import Foundation
import JellyfinAPI

class DetailViewDelegate: ViewDelegate {
    let playerStore: PlayerDelegate

    @Published var isPlaying: Bool = false

    public let item: BaseItemDto

    @Published var imageUrl: URL?

    var logTag: String {
        (item.type?.capitalized ?? "Unknown") + "DetailView"
    }

    @Published var itemSimilars: [BaseItemDto] = []
    //    @Published var actors: [BaseItemPerson] = []
    //    @Published var studio: String?
    //    @Published var director: String?
    //    @Published var itemPeople: [Person] = []

    @Published var seasons: [BaseItemDto] = []
    @Published var episodes: [BaseItemDto] = []

    @Published var selectedSeason: BaseItemDto?
    @Published var selectedEpisode: BaseItemDto?

    // Loads imageUrl
    func loadImageUrl() {
        logger.log.info("loading poster for item", tag: logTag)
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
        logger.log.info("loading similar items", tag: logTag)
        guard let userId = session.user?.id, let itemId = item.id else {
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

    func loadSeasons() {
        guard let itemId = item.id else {
            return
        }

        TvShowsAPI.getSeasons(seriesId: itemId) { result in
            switch result {
                case let .success(response):
                    self.seasons = response.items ?? []
                    self.loadEpisodes()
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }

    func loadEpisodes() {
        guard let itemId = item.id else {
            return
        }

        TvShowsAPI.getEpisodes(seriesId: itemId) { result in
            switch result {
                case let .success(response):
                    self.episodes = response.items?.sorted(by: { $0.indexNumber ?? 0 < $1.indexNumber ?? 0 }) ?? []

                    if let episode = self.episodes.last(where: \.isContinue) {
                        self.selectedEpisode = episode
                        self.selectedSeason = self.seasons.first(where: { $0.id == episode.seasonId })
                    }

                    if self.selectedSeason == nil {
                        self.selectedSeason = self.seasons.first
                        self.selectedEpisode = self.episodes.first
                    }

                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }

    func onAppear() {
        if ItemType(rawValue: item.type ?? "") == .episode {
            loadSeasons()
        }
        loadImageUrl()
        loadItemsSimilar()
    }

    func play() {
        print("PLAYING")
        isPlaying = true
        objectWillChange.send()
    }

    init(_ item: BaseItemDto) {
        self.item = item
        playerStore = .init(item)
    }
}
