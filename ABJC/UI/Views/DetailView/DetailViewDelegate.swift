/*
 ABJC - tvOS
 DetailViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import Foundation
import JellyfinAPI

class DetailViewDelegate: ViewDelegate {
    var logTag: String {
        (item.type?.capitalized ?? "Unknown") + "DetailView"
    }

    @Published var item: BaseItemDto

    var playbackItem: BaseItemDto {
        selectedEpisode ?? item
    }

    @Published var backdropImgUrl: URL?
    @Published var logoUrl: URL?

    @Published var itemRecommendations: [BaseItemDto] = []

    // Series Only:
    @Published var seasons: [BaseItemDto] = []
    @Published var episodes: [BaseItemDto] = []

    @Published var selectedSeason: BaseItemDto?
    @Published var selectedEpisode: BaseItemDto?

    init(_ item: BaseItemDto) {
        self.item = item
        super.init()
        loadImages()
        loadRecommended()

        switch ItemType(rawValue: item.type ?? "") {
            case .series: Task(priority: .userInitiated, operation: loadSeries)
            case .movie: break
            default: break
        }
    }

    func loadImages() {
        logger.log.info("loading images for item \(String(describing: item.id))", tag: logTag)
        guard let itemId = item.id else {
            return
        }

        if preferences.shouldFetchCoverArt  {
            let fetchRequest = MatchedCoverArt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "itemId == %@", itemId)

            do {
                let results = try session.viewContext.fetch(fetchRequest)
                if let match = results.first, let logo = match.logo {
                    logoUrl = logo
                }
            } catch {
                print("Error loading Persistence", error)
            }
        }

        // Backdrop
        ImageAPI.getItemImage(itemId: itemId, imageType: .backdrop) { result in
            switch result {
                case let .success(url): self.backdropImgUrl = url
                case let .failure(error): print(error)
            }
        }
    }

    func loadRecommended() {
        logger.log.info("loading recommendations for item \(String(describing: item.id))", tag: logTag)
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
                    self.itemRecommendations = response.items ?? []
                case let .failure(error):
                    self.alert = .init(.failedToLoadItems)
                    self.handleApiError(error)
            }
        }
    }

    @Sendable func loadSeries() async {
        logger.log.info("loading seris for item \(String(describing: item.id))", tag: logTag)
        guard let itemId = item.id,
              let userId = session.user?.id else {
            return
        }

        do {
            // Load Seasons
            logger.log.info("loading seasons for item \(itemId)", tag: logTag)
            let seasonsResponse = try await withCheckedContinuation { continuation in
                TvShowsAPI.getSeasons(seriesId: itemId) { result in
                    continuation.resume(returning: result)
                }
            }.get()

            DispatchQueue.main.async {
                self.seasons = seasonsResponse.items ?? []
            }

            logger.log.info("loading episodes for item \(itemId)", tag: logTag)
            let episodesResponse = try await withCheckedContinuation { continuation in
                TvShowsAPI.getEpisodes(seriesId: itemId, userId: userId, fields: [.overview]) { result in
                    continuation.resume(returning: result)
                }
            }.get()

            let currentEpisode = episodesResponse.items?
                .first(where: { $0.userData?.playedPercentage ?? 0 > 0 && $0.userData?.playedPercentage ?? 1 < 1 })
            let currentSeason = seasonsResponse.items?.first(where: { $0.id == currentEpisode?.seasonId })

            DispatchQueue.main.async {
                self.episodes = episodesResponse.items ?? []
                self.selectedEpisode = currentEpisode ?? seasonsResponse.items?.first
                self.selectedSeason = currentSeason ?? episodesResponse.items?.first
            }
        } catch {
            print(error)
        }
    }
}
