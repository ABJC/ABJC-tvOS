//
//  SearchView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

extension LibraryView {
    struct SearchView: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var query: String = ""
        
        @State var itemResults: [APIModels.MediaItem] = []
        @State var personResults: [APIModels.Person] = []

        
        @State var allItems: [APIModels.MediaItem] = []
        
        
        /// Edge Insets
        private var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
        
        private var height: CGFloat {
            var _height = session.preferences.posterType == .poster ? 340 : 300
            
            if session.preferences.showsTitles
            {
                _height += 100
            }
            return CGFloat(_height)
        }
        
        var body: some View {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    TextField("library.search.label", text: $query, onCommit: search)
                        .padding(.horizontal, 80)
                        .padding(.top, query.isEmpty ? 300 : 0)
                    
                    VStack(alignment: .leading) {
                        // Media Item Results
                        if itemResults.count != 0 && !query.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("library.search.results")
                                    .font(.title3)
                                    .padding(.horizontal, edgeInsets.leading)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 48) {
                                        ForEach(itemResults, id:\.id) { item in
                                            Button(action: {
                                                session.setFocus(item)
                                            }) {
                                                MediaCardView(item)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .frame(height: height)
                                    .padding(edgeInsets)
                                }.edgesIgnoringSafeArea(.horizontal)
                            }.edgesIgnoringSafeArea(.horizontal)
                            Divider()
                        }
                        
                        // Character & Crew Results
                        if personResults.count != 0 && !query.isEmpty {
                            PeopleRowView(
                                "library.search.results",
                                personResults
                            )
                        }
                        
                        // All Library Items
                        if let items = allItems {
                            Shelf(items, grouped: .title)
                                .environmentObject(session)
                        }
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }
            .onAppear(perform: load)
        }
    
        func load() {
            guard let jellyfin = session.jellyfin else {
                session.logout()
                return
            }
            API.items(jellyfin, nil) { (result) in
                switch result {
                    case .failure(let error):
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items of type", error)
                    case .success(let items):
                        self.allItems = items
                }
            }
        }
            
        func search() {
            guard let jellyfin = session.jellyfin else {
                session.logout()
                return
            }
            
            // Query Jellyfin for Media Items
            API.searchItems(jellyfin, query) { result in
                switch result {
                    case .success(let items): self.itemResults = items
                    case .failure(let error): print(error)
                }
            }
            
            // Query Jellyfin for People
            API.searchPeople(jellyfin, query) { result in
                switch result {
                    case .success(let items): self.personResults = items
                    case .failure(let error): print(error)
                }
            }
        }
    }
}



extension Character: Identifiable {
    public var id: String { String(self) }
}
