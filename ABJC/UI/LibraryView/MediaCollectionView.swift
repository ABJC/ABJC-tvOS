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
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        if let items = items {
                            GroupingViewContainer(items).environmentObject(session)
                        }
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }
            .onAppear(perform: load)
        }
        
        func load() {
            API.items(session.jellyfin!, type) { (result) in
                switch result {
                    case .failure(let error):
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items of type \(String(describing: type?.rawValue))", error)
                    case .success(let items):
                        self.items = items
                }
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
