/*
 ABJC - tvOS
 DetailView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 19.11.21
 */

import JellyfinAPI
import SwiftUI

class DetailViewDelegate2: ViewDelegate {
    var logTag: String {
        (item.type?.capitalized ?? "Unknown") + "DetailView"
    }

    @Published var item: BaseItemDto

    var playbackItem: BaseItemDto {
        selectedEpisode ?? item
    }

    @Published var backdropImgUrl: URL?
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

struct DetailView: View {
    @StateObject var store: DetailViewDelegate2
    @FocusState var focus: String?

    var backdrop: some View {
        AsyncImage(url: store.backdropImgUrl) { image in
            image
                .renderingMode(.original)
                .resizable()
        } placeholder: {
            Blurhash(store.item.blurhash(for: .backdrop))
        }
        .frame(width: 1920, height: 1080, alignment: .center)
    }

    var body: some View {
        ZStack(alignment: .top) {
            backdrop
            ScrollView(.vertical, showsIndicators: false) {
                titleView
                    .frame(width: 1920, height: 1080 * 2 / 3, alignment: .center)
                    .focusSection()

                ZStack {
                    Blur(style: .prominent)
                    VStack {
                        detailView
                            .frame(width: 1920, height: 1080 * 1 / 3, alignment: .top)
                            .focusSection()

                        if store.item.type == ItemType.series.rawValue {
                            SeasonAndEpisodeView(store: store)
                        }
                        peopleView
                            .focusSection()
                        //                        recommendedView
                    }
                }
            }.frame(width: 1920, height: 1080, alignment: .center)
        }
        .frame(width: 1920, height: 1080, alignment: .center)
    }

    var titleView: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if store.item.type == ItemType.series.rawValue,
                       let selectedSeason = store.selectedSeason,
                       let selectedEpisode = store.selectedEpisode {
                        Text(selectedEpisode.name ?? "No Name")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.primary)

                        Text(store.item.name ?? "No Name")
                            .bold()
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text(String(format: "S%02d E%02d", selectedSeason.indexNumber ?? 0, selectedEpisode.indexNumber ?? 0))
                            .bold()
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(store.item.name ?? "No Name")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.primary)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding(80)
    }

    var detailView: some View {
        HStack(alignment: .top) {
            // Buttons
            VStack(alignment: .leading) {
                NavigationLink(destination: { PlayerViewContainer(store: .init(store.item)) }) {
                    if let episode = store.selectedEpisode {
                        Label(episode.isContinue ? "Continue" : "Play", systemImage: "play")
                            .frame(width: 400)
                    } else {
                        Label("Play", systemImage: "play")
                            .frame(width: 400)
                    }
                }
                .focused($focus, equals: "playBtn")
                .onChange(of: store.selectedEpisode) { _ in
                    focus = "playBtn"
                }
                Button(action: {
                    guard let itemId = store.item.id else {
                        return
                    }
                    store.item.userData?.isFavorite = true

                    ItemUpdateAPI.updateItem(itemId: itemId, baseItemDto: store.item) { result in
                        switch result {
                            case .success: break
                            case let .failure(error):
                                self.store.alert = .init(.failedToLoadItems)
                                self.store.handleApiError(error)
                        }
                    }
                }) {
                    HStack(alignment: .center) {
                        Label("Favorite", systemImage: store.item.userData?.isFavorite ?? false ? "star" : "star.fill")
                            .frame(width: 400)
                    }.frame(width: 400)
                }
            }

            // Overview & Metadata
            VStack(alignment: .leading, spacing: 10) {
                Text(store.item.overview ?? "No Overview")
                    .lineLimit(4)

                Text("Drama 2021 - 35 Min.")
                    .foregroundColor(.secondary)
            }

            // Ratings
            VStack {
                Text("Critics & Reviews")
                if let rating = store.item.communityRating {
                    HStack {
                        Image(systemName: "star")
                        Text(String(format: "%.1f", rating))
                    }
                }
                if let rating = store.item.criticRating {
                    HStack {
                        Image(systemName: "star")
                        Text(String(format: "%.1f", rating))
                    }
                }
            }
        }.padding([.horizontal, .top], 80)
    }

    /// People (Actors, etc.)
    var peopleView: some View {
        Group {
            Divider().padding(.horizontal, 80)
            PeopleCardRow("Cast & Crew", store.item.people ?? [])
        }
        .edgesIgnoringSafeArea(.horizontal)
        .accessibilityIdentifier("peopleView")
    }

    /// Recommended Items View
    var recommendedView: some View {
        Group {
            Divider().padding(.horizontal, 80)
            MediaCardRow(store: .init(), label: "Similar Items", items: store.itemRecommendations)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .accessibilityIdentifier("recommendedView")
    }
}

// Group {
//    switch ItemType(rawValue: item.type ?? "") ?? .episode {
//        case .movie:
//            MovieDetailView(store: .init(item)).accessibilityIdentifier("movieDetailView")
//        case .series:
//            SeriesDetailView(store: .init(item)).accessibilityIdentifier("seriesDetailView")
//        default:
//            Text("No View for Type: \(item.type ?? "")")
//    }
// }

// struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(item: .preview)
//    }
// }
