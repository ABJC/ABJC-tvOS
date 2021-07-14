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
        
        var body: some View {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    TextField("library.search.label", text: $query, onCommit: search)
                        .padding(.horizontal, 80)
                    
                    VStack(alignment: .leading) {
                        // Media Item Results
                        if itemResults.count != 0 {
                            MediaRowView(
                                "library.search.results",
                                itemResults
                            )
                            Divider()
                        }
                        
                        // Character & Crew Results
                        if personResults.count != 0 {
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
