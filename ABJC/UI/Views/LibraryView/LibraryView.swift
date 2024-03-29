/*
 ABJC - tvOS
 LibraryView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import SwiftUI

struct LibraryView: View {
    // Store for View
    @StateObject var store: LibraryViewDelegate = .init()
    @State private var selectedTab: Tab = .movies
    @State var hasUpdateNotice: Bool = true
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

                SearchView()
                    .tabItem {
                        Text(Tab.search.title)
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(Tab.search)

                PreferencesView()
                    .tabItem { Text("Preferences") }
                    .tag(Tab.preferences)
            }
            .frame(width: 1920, alignment: .center)
            .focusSection()
        }
        .id(store.preferences.betaShowWatchNowTab.description)
        .navigationBarTitle(selectedTab.title)
        .accessibilityIdentifier("main-nav")
        .onAppear(perform: store.updateCoverArt)
//        .fullScreenCover(isPresented: $hasUpdateNotice, onDismiss: {}, content: {
//            UpdateNotice(preferences: store.preferences, updateNotice: store.preferences.updateNotice!)
//        })
//        .onAppear {
//            hasUpdateNotice = store.preferences.updateNotice != nil
//        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
