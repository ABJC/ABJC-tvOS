//
//  LibraryView.swift
//  LibraryView
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI

struct LibraryView: View {
    // Store for View
    @StateObject
    var store: LibraryViewDelegate = .init()
    @State
    private var selectedTab: Tab = .movies

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                //            WatchNowView()
                //                .tabItem({ Text(Tab.watchnow.title) })
                //                .tag(Tab.watchnow)

                MediaCollectionView(itemType: .movie)
                    .tabItem { Text(Tab.movies.title) }
                    .tag(Tab.movies)

                MediaCollectionView(itemType: .series)
                    .tabItem { Text(Tab.shows.title) }
                    .tag(Tab.shows)

                //            SearchView()
                //                .tabItem({
                //                    Text(Tab.search.title)
                //                    Image(systemName: "magnifyingglass")
                //                })
                //                .tag(Tab.search)

                PreferencesView()
                    .tabItem { Text("Preferences") }
                    .tag(Tab.preferences)
            }
        }
        .id(store.preferences.betaShowWatchNowTab.description)
        .navigationBarTitle(selectedTab.title)
        .accessibilityIdentifier("main-nav")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
