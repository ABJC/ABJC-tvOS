//
//  SeriesPage.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI
import URLImage

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
        @State var selectedSeason: APIModels.Season? = nil
        @State var needsViewUpdate: Bool = false
        
        /// Currently Selected Episode
        @State var selectedEpisode: APIModels.Episode? = nil
        
        /// Similar Items
        @State var similarItems: [APIModels.MediaItem] = []
        
        var hasNext: Bool {
            guard let selection = selectedSeason else {
                return false
            }
            guard let index = seasons.firstIndex(of: selection) else {
                return false
            }
            
            return (index + 1) < seasons.count
        }
        
        var hasPrev: Bool {
            guard let selection = selectedSeason else {
                return false
            }
            guard let index = seasons.firstIndex(of: selection) else {
                return false
            }
            
            return (index - 1) >= 0
        }
        
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
        
        private var url: URL? {
            guard let jellyfin = session.jellyfin else {
                DispatchQueue.main.async {
                    session.itemPlaying = nil
                    session.itemFocus = nil
                }
                session.logout()
                return nil
            }
            return API.imageURL(jellyfin, item.id, .backdrop)
        }
        
        private var primaryUrl : URL? {
            guard let jellyfin = session.jellyfin else {
                DispatchQueue.main.async {
                    session.itemPlaying = nil
                    session.itemFocus = nil
                }
                session.logout()
                return nil
            }
            return API.imageURL(jellyfin, item.id, .primary)
        }
        

        var body: some View {
            ZStack {
                backdrop.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: true) {
                    headerView
                        .padding(80)
                        .frame(width: 1920, height: 1080 + 50)
                    
//                    #warning("INFO VIEW")
                    episodeView
                    
//                    infoView
                    peopleView
//                    recommendedView
                    
                }
            }.edgesIgnoringSafeArea(.all)
            .onAppear(perform: load)
        }
       
        /// URLImage
        private var image: some View {
            Group() {
                if let url = url {
                    URLImage(
                        url: url,
                        empty: { EmptyView() },
                        inProgress: { _ in EmptyView() },
                        failure:  { _,_ in EmptyView() }
                    ) { image in
                        image
                            .renderingMode(.original)
                            .resizable()
                    }
                } else {
                    EmptyView()
                }
            }
        }
        
        /// Backdrop
        var backdrop: some View {
            Group() {
                image
                Blur()
            }
        }
        
        private var primaryImage: some View {
            Group() {
                if let url = primaryUrl {
                    URLImage(
                        url: url,
                        empty: { EmptyView() },
                        inProgress: { _ in EmptyView() },
                        failure:  { _,_ in EmptyView() }
                    ) { image in
                        image
                            .renderingMode(.original)
                            .resizable()
                    }
                } else {
                    EmptyView()
                }
            }
        }
        
        /// Header
        var headerView: some View {
            ButtonArea(play) { isFocused in
                VStack(alignment: .leading) {
                    primaryImage
                        .aspectRatio(2/3, contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(width: 400, height: 600)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            if let episode = selectedEpisode {
                                Text("S\(String(format: "%02d", selectedSeason!.index ))x\(String(format: "%02d", episode.index ?? 0)) " + episode.name)
                                    .bold()
                                    .font(.title2)
                            } else {
                                Text(item.name)
                                    .bold()
                                    .font(.title2)
                            }
                            HStack {
                                if selectedEpisode != nil {
                                    Text(item.name)
                                }
                                Text(item.year != nil ? "\(String(item.year!))" : "")
                                Text(item.type.rawValue)
                            }.foregroundColor(.secondary)
                        }
                        Spacer()
                        PlayButton(isContinue ? "buttons.play" : "buttons.continue", play)
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
            }
            .prefersDefaultFocus(in: namespace)
            .padding(.horizontal, 80)
            .padding(.bottom, 80)
        }
        
        /// Buttongroup for Season selection
        var seasonSwitcher: some View {
            HStack {
                Button(action: {
                    if let season = self.selectedSeason {
                        let prev = seasons.firstIndex(of: season)! - 1
                        needsViewUpdate = true
                        self.selectedSeason = seasons[prev]
                    }
                }) {
                    Image(systemName: "chevron.left")
                }.disabled(!hasPrev)
                Text(selectedSeason?.name ?? "-")
                    .font(.headline)
                    .frame(width: 200)
                Button(action: {
                    if let season = self.selectedSeason {
                        let next = seasons.firstIndex(of: season)! + 1
                        needsViewUpdate = true
                        self.selectedSeason = seasons[next]
                    }
                }) {
                    Image(systemName: "chevron.right")
                }.disabled(!hasNext)
            }
        }
        
        /// Episode View with Season Switcher
        var episodeView: some View {
            VStack() {
                seasonSwitcher
                EpisodeRowView(episodes,
                               seasons,
                               $needsViewUpdate,
                               $selectedSeason,
                               $selectedEpisode)
            }
        }
        
        /// People (Actors, etc.)
        var peopleView: some View {
            Group {
                if let item = detailItem {
                    Divider().padding(.horizontal, 80)
                    PeopleRowView("itemdetail.people.label", item.people ?? [])
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
        
        
        func play() {
            if let episode = selectedEpisode {
                session.setPlayItem(.init(episode))
            } else {
                print("ERROR")
            }
        }
        
        
        func findNextUp() {
            if let nextUp = self.episodes.first(where: { !$0.userData.played }) {
                self.selectedEpisode = nextUp
                self.selectedSeason = self.seasons.first(where: { $0.index == nextUp.parentIndex })
            }
        }
        
        func load() {
            // Fetch Seasons
            API.seasons(session.jellyfin!, self.item.id) { result in
                switch result {
                    case .success(let items):
                        self.seasons = items.sorted(by: {$0.index == 0 || $0.index < $1.index})
                        self.selectedSeason = self.seasons.isEmpty ? nil : self.seasons.first!
                        // Fetch Episodes
                        API.episodes(session.jellyfin!, self.item.id) { result in
                            switch result {
                                case .success(let items):
                                    self.episodes = items
                                    self.findNextUp()
                                case .failure(let error):
                                    session.setAlert(.api, "Failed to fetch Episodes", "Failed to fetch Episodes for \(item.id)", error)
                            }
                        }
                    case .failure(let error):
                        session.setAlert(.api, "Failed to fetch Seasons", "Failed to fetch Seasons for \(item.id)", error)
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
