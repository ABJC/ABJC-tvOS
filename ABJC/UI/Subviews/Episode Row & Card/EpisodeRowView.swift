//
//  EpisodeRowView.swift
//  ABJC
//
//  Created by Noah Kamara on 05.04.21.
//

import SwiftUI

extension LibraryView
{
    struct EpisodeRowView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Edge Insets
        private var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
        
        /// Items
        private let items: [APIModels.Episode]
        private let seasons: [APIModels.Season]
        
        @Binding var selectedSeason: APIModels.Season?
        @Binding var needsViewUpdate: Bool
        @Binding var selectedEpisode: APIModels.Episode?
        
        /// Initializer
        /// - Parameters:
        ///   - label: Row Label
        ///   - items: Row Items
        public init(
            _ items: [APIModels.Episode],
            _ seasons: [APIModels.Season],
            _ needsViewUpdate: Binding<Bool>,
            _ selectedSeason: Binding<APIModels.Season?>,
            _ selectedEpisode: Binding<APIModels.Episode?>
        ) {
            self.items = items
            self.seasons = seasons
            self._needsViewUpdate = needsViewUpdate
            self._selectedSeason = selectedSeason
            self._selectedEpisode = selectedEpisode
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 48) {
                        ForEach(items, id:\.id) { item in
                            Button(action: {
                                DispatchQueue.main.async {
                                    self.selectedEpisode = item
                                }
                            }) {
                                EpisodeCardView(item)
                                    .focusable(true, onFocusChange: { focused in
                                        if selectedSeason?.id != item.seasonId {
                                            self.selectedSeason = seasons.first(where: { item.seasonId == $0.id })
                                        }
                                    })
                            }
                            .buttonStyle(PlainButtonStyle())
                            .id(item)
                            
                        }
                    }
                    .frame(height: 500)
                    .padding(edgeInsets)
                    .onChange(of: selectedSeason) { selectedSeason in
                        if !needsViewUpdate {
                            return
                        }
                        if let season = selectedSeason {
                            needsViewUpdate = false
                            let episode = items.first(where: { $0.seasonId == season.id})
                            withAnimation(.easeIn) {
                                proxy.scrollTo(episode, anchor: .leading)
                            }
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    //struct MediaRowView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MediaRowView()
    //    }
    //}
}

