//
//  MoviePage.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI

extension LibraryView
{
    struct MoviePage: View {
        /// Focus Namespace
        @Namespace private var namespace
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Media Item
        private let item: APIModels.MediaItem
        
        /// Detail Item
        @State var detailItem: APIModels.Movie?
        
        /// Similar Items
        @State var similarItems: [APIModels.MediaItem] = []
        
        private var isContinue: Bool {
            if item.userData.playbackPosition != 0 {
                return true
            }
            return false
        }
        
        /// Initializer
        /// - Parameter item: Series
        public init(_ item: APIModels.MediaItem) {
            self.item = item
        }
        
        var body: some View {
            ZStack {
                backdrop.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: true) {
                    headerView
                        .padding(80)
                        .frame(width: 1920, height: 1080 + 50)
//                    #warning("INFO VIEW")
//                    infoView
                    peopleView
//                    recommendedView
                    
                }
            }.edgesIgnoringSafeArea(.all)
            .onAppear(perform: load)
        }
        
        var backdrop: some View {
            Blur()
        }
        
        /// Header
        var headerView: some View {
            ButtonArea(play) { isFocus in 
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
                        PlayButton(isContinue ? "buttons.play" : "buttons.continue", play)
                        .padding(.trailing)
                    }
                    
                    if item.overview != nil {
                        Divider()
                        HStack() {
                            Text(self.item.overview!)
                        }
                    } else if detailItem?.overview != nil {
                        Divider()
                        HStack() {
                            Text(self.detailItem!.overview!)
                        }
                    }
                }
            }
            .prefersDefaultFocus(in: namespace)
            .padding(.horizontal, 80)
            .padding(.bottom, 80)
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
            if let item = detailItem {
                session.setPlayItem(.init(item))
            }
        }
        
        /// Loads Content From API
        func load() {
            // Fetch Item Detail
            API.movie(session.jellyfin!, item.id) { result in
                switch result {
                    case .success(let item): self.detailItem = item
                    case .failure(let error): session.setAlert(.api, "Failed to fetch item detail", "getMovie failed", error)
                }
            }
            
            // Fetch Images for Item
            //        session.api.getImages(for: item.id) { result in
            //            switch result {
            //                case .success(let images): self.images = images
            //                case .failure(let error):
            //                    var alert = AlertError("unknown", "unknown")
            //                    if session.preferences.isDebugEnabled {
            //                        alert = AlertError("alerts.apierror", error.localizedDescription)
            //                    } else {
            //                        alert = AlertError("DebugInfo", "Trying to retrieve image for \(item.name) resulted in error")
            //                    }
            //
            //                    DispatchQueue.main.async {
            //                        session.alert = alert
            //                    }
            //            }
            //        }
            
            // Fetch Similar Items
            //        API.similar(for: item.id) { result in
            //            switch result {
            //                case .success(let items): self.similarItems = items
            //                case .failure(let error): session.setAlert(.api, "Fetching Similar Items Failed", "API.similar", error)
            //            }
            //        }
        }
    }
    
//    struct MoviePage_Previews: PreviewProvider {
//        static var previews: some View {
//            MoviePage()
//        }
//    }
}

