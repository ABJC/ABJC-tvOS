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
                        if itemResults.count != 0 {
                            MediaRowView(
                                "library.search.results",
                                itemResults
                            )
                            Divider()
                        }
                        
                        if personResults.count != 0 {
                            PeopleRowView(
                                "library.search.results",
                                personResults
                            )
                        }
                        
                        if let items = allItems {
                            GroupingViewContainer(items).environmentObject(session)
                        }
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }
            .onAppear(perform: load)
        }
    
        func load() {
            API.items(session.jellyfin!, nil) { (result) in
                switch result {
                    case .failure(let error):
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items of type", error)
                    case .success(let items):
                        self.allItems = items
                }
            }
        }
            
        func search() {
            API.searchItems(session.jellyfin!, query) { result in
                switch result {
                    case .success(let items): self.itemResults = items
                    case .failure(let error): print(error)
                }
            }
            API.searchPeople(session.jellyfin!, query) { result in
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
