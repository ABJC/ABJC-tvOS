//
//  MediaCollectionView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

extension LibraryView
{
    struct MediaCollectionView: View
    {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var isLoading: Bool = false
        
        /// MediaType
        private let type: APIModels.MediaType?
        
        /// filtered items
        @State var items: [APIModels.MediaItem] = []

        /// Initializer
        /// - Parameter type: MediaType for API fetch
        public init(_ type: APIModels.MediaType? = nil) {
            self.type = type
        }
        
        var body: some View
        {
            NavigationView {
                if items.count != 0 {
                    Shelf(items, grouped: session.preferences.collectionGrouping)
                        .environmentObject(session)
                        .id(session.preferences.collectionGrouping.rawValue + String(session.preferences.showsTitles))
                } else if isLoading {
                    ActivityIndicatorView()
                } else {
                    Shelf(items, grouped: session.preferences.collectionGrouping)
                        .environmentObject(session)
                        .id(session.preferences.collectionGrouping.rawValue + String(session.preferences.showsTitles))
                }
            }
            .onAppear(perform: load)
        }
        
        func load() {
            guard let jellyfin = session.jellyfin else {
                session.logout()
                return
            }
            
            print("STARTED LOADING", self.isLoading)
            API.items(jellyfin, type) { (result) in
                switch result {
                    case .failure(let error):
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items of type \(String(describing: type?.rawValue))", error)
                    case .success(let items):
                        self.items = items
                }
                
                print("FINISHED LOADING", self.isLoading)
            }
        }
    }
    
    struct MediaCollectionView_Previews: PreviewProvider
    {
        static var previews: some View
        {
            MediaCollectionView()
        }
    }
}
