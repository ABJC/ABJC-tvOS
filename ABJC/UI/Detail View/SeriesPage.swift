//
//  SeriesPage.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI

extension LibraryView
{
    struct SeriesPage: View {
        /// Focus Namespace
        @Namespace private var namespace
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Media Item
        private let item: APIModels.MediaItem
        
        /// Detail Item
        @State var detailItem: APIModels.Series?
        
        /// Series Seasons
        @State var seasons: [APIModels.Season] = []
        
        /// Series Episodes
        @State var episodes: [APIModels.Episode] = []
        
        /// Currently Selected Season
        @State var selectedSeason: Int? = nil
        
        /// Currently Selected Episode
        @State var selectedEpisode: APIModels.Episode? = nil
        
        /// Similar Items
        @State var similarItems: [APIModels.MediaItem] = []
        
        private var isContinue: Bool {
//            if item.userData.playbackPosition != 0 {
//                return true
//            }
            return false
        }
        
        /// Initializer
        /// - Parameter item: Series
        public init(_ item: APIModels.MediaItem) {
            self.item = item
        }
        

        var body: some View {
            GeometryReader { geo in
                ZStack {
                    backdrop.edgesIgnoringSafeArea(.all)
                    ScrollView(.vertical, showsIndicators: true) {
                        headerView
                            .padding(80)
                            .frame(width: geo.size.width, height: geo.size.height + 50)
//                        #warning("INFO VIEW")
                        episodeView
//                        infoView
                        peopleView
                        Button(action: {
                            print("HELLO")
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Hello")
                                Spacer()
                            }
                        })
//                        recommendedView
                        
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }.edgesIgnoringSafeArea(.all)
            .onAppear(perform: load)
        }
        
        var backdrop: some View {
            Blur()
        }
        
        /// Header
        var headerView: some View {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .bold()
                            .font(.title2)
                        HStack {
                            Text(item.year != nil ? "\(String(item.year!))" : "")
                            Text(item.type.rawValue)
                        }.foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: {
//                    if let item = self.detailItem {
//                        playerStore.play(item)
//                    }
                    }) {
                        Text(isContinue ? "buttons.play" : "buttons.continue")
                            .bold()
                            .textCase(.uppercase)
                            .frame(width: 300)
                    }
//                    .disabled(detailItem == nil)
                    .foregroundColor(.accentColor)
                    .padding(.trailing)
                    .prefersDefaultFocus(in: namespace)
                    
                }
                if item.overview != nil {
                    Divider()
                    HStack() {
                        Text(self.item.overview!)
                    }
                } else if item.overview != nil {
                    Divider()
                    HStack() {
                        Text(self.item.overview!)
                    }
                }
            }
            .focusScope(namespace)
            .padding(.horizontal, 80)
            .padding(.bottom, 80)
        }
        
        
        var episodeView: some View {
            VStack {
                Picker(
                    selection: $selectedSeason,
                    label: Text("Picker Name"),
                    content: {
                        ForEach(seasons) { season in
                            Text("\(season.index)").tag(season.index)
                        }
                    })
                
                EpisodeRowView("Season \(selectedSeason)",
                               episodes,
                               $selectedSeason,
                               $selectedEpisode)
                
            }
        }
        
        /// People (Actors, etc.)
        var peopleView: some View {
            Group {
                if let item = detailItem {
                    Divider().padding(.horizontal, 80)
                    PeopleRowView("itemdetail.people.label", self.detailItem!.people ?? [])
                }
            }.edgesIgnoringSafeArea(.horizontal)
        }
        
        
        /// Recommended Items View
        var recommendedView: some View {
            Group {
                Divider().padding(.horizontal, 80)
                MediaRowView("itemdetail.recommended.label", self.similarItems)
            }
        }
        
        
        func load()
        {
            // Fetch Seasons
            API.seasons(session.jellyfin!, self.item.id) { result in
                switch result {
                    case .success(let items):
                        self.seasons = items.sorted(by: {$0.index == 0 || $0.index < $1.index})
                        self.selectedSeason = self.seasons.isEmpty ? nil : 0
                    case .failure(let error):
                        session.setAlert(.api, "Failed to fetch Seasons", "Failed to fetch Seasons for \(item.id)", error)
                }
                
                // Fetch Episodes
                API.episodes(session.jellyfin!, self.item.id) { result in
                    switch result {
                        case .success(let items):
                            self.episodes = items
                        case .failure(let error):
                            session.setAlert(.api, "Failed to fetch Episodes", "Failed to fetch Episodes for \(item.id)", error)
                    }
                }
            }
            
//            // Fetch Episodes
//            session.api.getEpisodes(for: self.item.id) { result in
//                switch result {
//                    case .success(let items):
//                        self.episodes = items.sorted(by: {$0.parentIndex <= $1.parentIndex && $0.index ?? 0 <= $1.index ?? 0})
//                        self.selectedEpisode = episodes.first(where: {$0.userData.played != true})
//                        if selectedEpisode != nil {
//                            if let currentSeason = seasons.first(where: {$0.index == selectedEpisode!.parentIndex}) {
//                                self.selectedSeason = seasons.firstIndex(of: currentSeason)
//                            }
//                        }
//                    case .failure(let error):
//                        var alert = AlertError("unknown", "unknown")
//                        if session.preferences.isDebugEnabled {
//                            alert = AlertError("DebugInfo", "Couldn't fetch episodes \(error)")
//                        } else {
//                            alert = AlertError("alerts.apierror", "Couldn't fetch episodes")
//
//
//                        }
//
//                        DispatchQueue.main.async {
//                            session.alert = alert
//                        }
//                }
//            }
        }
        
    }
    
//    struct SeriesPage_Previews: PreviewProvider {
//        static var previews: some View {
//            SeriesPage()
//        }
//    }
}
