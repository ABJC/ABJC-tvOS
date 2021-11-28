/*
 ABJC - tvOS
 DetailView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import JellyfinAPI
import SwiftUI

struct DetailView: View {
    @StateObject var store: DetailViewDelegate
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
        .accessibilityIdentifier("detailView")
    }

    var titleView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
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
                }.frame(width: 3.5 / 5 * 1920, alignment: .topLeading)
                AsyncImg(url: store.logoUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Text("ERROR")
                }
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
