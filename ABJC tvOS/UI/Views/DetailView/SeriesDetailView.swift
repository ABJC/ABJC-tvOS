/*
 ABJC - tvOS
 SeriesDetailView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import SwiftUI

struct SeriesDetailView: View {
    @StateObject var store: DetailViewDelegate

    @Namespace var namespace

    var body: some View {
        ZStack {
            backdrop.edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: true) {
                headerView.frame(width: 1920, height: 1080, alignment: .center)
                episodeView
                peopleView
                recommendedView
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: store.onAppear)

        .fullScreenCover(isPresented: $store.isPlaying) {
            self.store.isPlaying = false
        } content: {
            PlayerContainerView()
                .environmentObject(store.playerStore)
        }
    }

    var headerView: some View {
        NavigationLink(destination: {
            PlayerContainerView()
                .environmentObject(store.playerStore)
        }) {
            VStack(alignment: .leading) {
                // Poster Image
                poster
                HStack(alignment: .top) {
                    // Item Label
                    VStack(alignment: .leading) {
                        Text(store.item.name ?? "No Name")
                            .bold()
                            .font(.title2)
                        Text(store.item.productionYear != nil ? "\(String(store.item.productionYear!))" : "")
                            .foregroundColor(.secondary)
                    }.accessibilityIdentifier("titleLbl")

                    Spacer()
                    // Play Button
                    PlayButton(store.item.isContinue ? "Continue" : "Play")
                        .accessibilityIdentifier("playBtn")
                        .padding(.trailing, 80)
                }

                if store.item.overview != nil {
                    Divider()
                    HStack {
                        Text(store.item.overview!)
                    }.accessibilityIdentifier("overviewLbl")
                } else {
                    Text("IS NIL")
                }
            }
        }
        .buttonStyle(.plain)
        .prefersDefaultFocus(in: namespace)
        .padding(80)
    }

    /// Episode View with Season Switcher
    var episodeView: some View {
        VStack {
            seasonSwitcher
//            EpisodeRowView(episodes,
//                           seasons,
//                           $needsViewUpdate,
//                           $selectedSeason,
//                           $selectedEpisode)
        }
    }

    /// Buttongroup for Season selection
    var seasonSwitcher: some View {
        HStack {
            Button(action: {
                if let season = store.selectedSeason {
                    let prev = store.seasons.firstIndex(of: season)! - 1
                    store.selectedSeason = store.seasons[prev]
                }
            }) {
                Image(systemName: "chevron.left")
            }.disabled(store.seasons.first == store.selectedSeason)
            Text(store.selectedSeason?.name ?? "-")
                .font(.headline)
                .frame(width: 200)
            Button(action: {
                if let season = store.selectedSeason {
                    let next = store.seasons.firstIndex(of: season)! + 1
                    store.selectedSeason = store.seasons[next]
                }
            }) {
                Image(systemName: "chevron.right")
            }.disabled(store.seasons.last == store.selectedSeason)
        }
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
            MediaCardRow(store: .init(), label: "Similar Items", items: store.itemSimilars)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .accessibilityIdentifier("recommendedView")
    }

    // Poster View
    var poster: some View {
        AsyncImg(url: store.imageUrl) { image in
            image
                .renderingMode(.original)
                .resizable()
        } placeholder: {
            Blur()
        }
        .aspectRatio(2 / 3, contentMode: .fill)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .frame(width: 400, height: 600)
        .shadow(radius: 5)
    }

    /// Backdrop
    var backdrop: some View {
        Blurhash(store.item.blurhash(for: .backdrop))
    }
}

// struct SeriesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeriesDetailView(store: .init(<#T##item: BaseItemDto##BaseItemDto#>))
//    }
// }
