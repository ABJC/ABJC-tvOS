//
//  LibraryView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

struct LibraryView: View {
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        TabView() {
            if session.preferences.showsWatchNowTab {
                WatchNowView()
                    .tabItem({ Text("library.watchnow.label") })
                    .tag(0)
                    .disabled(!session.preferences.tabs.contains(.watchnow))
            }
            
            if session.preferences.showsMoviesTab {
                MediaCollectionView(.movie)
                    .tabItem({ Text("library.movies.label") })
                    .tag(1)
            }

            if session.preferences.showsSeriesTab {
                MediaCollectionView(.series)
                    .tabItem({ Text("library.series.label") })
                    .tag(2)
            }

            if session.preferences.showsSearchTab {
                SearchView()
                    .tabItem({
                        Text("library.search.label")
                        Image(systemName: "magnifyingglass")
                    })
                    .tag(3)
            }
            
            PreferencesView()
                .tabItem({ Text("library.preferences.label") })
                .tag(4)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
