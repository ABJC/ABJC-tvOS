/*
 ABJC - tvOS
 SeasonAndEpisodeView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import JellyfinAPI
import SwiftUI

struct EpisodeCard: View {
    private let item: BaseItemDto
    @State var thumbnailURL: URL?
    private let action: () -> Void
    @Namespace var namespace

    @State var showDetail: Bool = false

    init(_ item: BaseItemDto, _ action: @escaping () -> Void) {
        self.item = item
        self.action = action
    }

    func loadThumbnailURL() {
        guard let itemId = item.id else {
            return
        }

        ImageAPI.getItemImage(itemId: itemId, imageType: .primary) { result in
            switch result {
                case let .success(url): self.thumbnailURL = url
                case let .failure(error): print(error)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: action) {
                AsyncImg(url: thumbnailURL) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                } placeholder: {
                    Text("ERROR")
                }
                .aspectRatio(16 / 9, contentMode: .fill)
                .clipped()
                .cornerRadius(10, antialiased: true)
                .frame(width: 548, height: 308)
            }.buttonStyle(.plain)

            Button(action: { self.showDetail.toggle() }) {
                VStack(alignment: .leading) {
                    Text("Folge \(item.indexNumber ?? 0)")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)

                    Text(item.name ?? "No Title")
                        .bold()

                    Text(item.overview ?? "")
                        .lineLimit(3)
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .frame(width: 548, alignment: .topLeading)
            }.buttonStyle(.plain)
        }
        .onAppear(perform: loadThumbnailURL)
        .fullScreenCover(isPresented: $showDetail) {} content: {
            ZStack(alignment: .center) {
                Blur().edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Folge \(item.indexNumber ?? 0)")
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)

                    Text(item.name ?? "No Title")
                        .font(.headline)
                        .bold()

                    Text(item.overview ?? "")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .animation(.default, value: showDetail)
                .frame(width: 800)
            }
            .frame(width: 1920, height: 1080, alignment: .center)
        }
    }
}

struct SeasonAndEpisodeView: View {
    enum Focus: Hashable {
        case seasons
        case season(BaseItemDto)
    }

    public var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
    @Namespace var namespace

    /// Title image  aspect ratio
    public var imageAspectRatio: CGFloat {
        store.preferences.posterType == .poster ? 2 / 3 : 16 / 9
    }

    @ObservedObject var store: DetailViewDelegate2
    @FocusState var focusedField: Focus?
    @State var lastFocus: Focus?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(store.seasons, id: \.id) { season in
                    CustomButton({ store.selectedSeason = season }) { hasFocus, _ in
                        Text(season.name ?? "Season \(season.indexNumber ?? 0)")
                            .padding(10)
                            .foregroundColor(store.selectedSeason == season ? .primary : .secondary)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThickMaterial)
                                    .opacity(hasFocus ? 1 : 0)
                            )
                            .onChange(of: hasFocus) { newValue in
                                guard newValue else { return }
                                print("store.selectedSeason")
                                store.selectedSeason = season
                            }
                    }
                    .focused($focusedField, equals: .season(season))
                }
            }
            .font(.headline)
            .padding(.leading, 80)
        }
        .focusSection()

        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                LazyHStack(spacing: 0) {
                    ForEach(store.episodes, id: \.id) { item in
                        EpisodeCard(item) {
                            store.selectedEpisode = item
                        }
                        .padding(.horizontal, 24)
                        .id(item.id)
                    }
                }
                .padding(edgeInsets)
                .edgesIgnoringSafeArea(.horizontal)
                .onChange(of: store.selectedSeason) { newValue in
                    DispatchQueue.main.async {
                        let startOfSeason = store.episodes.first(where: { $0.seasonId == newValue?.id })
                        withAnimation {
                            scrollViewProxy.scrollTo(startOfSeason?.id, anchor: UnitPoint(x: 0, y: 0))
                        }
                    }
                }
            }
        }.focusSection()
    }
}

// struct SeasonAndEpisodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonAndEpisodeView(store: .init(.init))
//    }
// }
