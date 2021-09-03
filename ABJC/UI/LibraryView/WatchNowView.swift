//
//  WatchNowView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI

extension LibraryView
{
    struct WatchNowView: View
    {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// filtered items
        @State var latestItems: [APIModels.MediaItem] = []
        @State var items: [APIModels.MediaItem] = []
        
        var body: some View
        {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    // Latest Movies & TV Shows
                    VStack(alignment: .leading) {
                        CoverRowView(latestItems)
                        
                        if items.count != 0, let items = items {
                            Shelf(items, grouped: session.preferences.collectionGrouping)
                                .environmentObject(session)
                                .id(session.preferences.collectionGrouping)
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
            
            // Fetch latest Movies & TV Shows
            API.latest(jellyfin) { (result) in
                switch result {
                    case .failure(let error):
                        API.logError(method: .latest, error: error, session: session, in: .watchNow)
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items (latest)", error)
                    case .success(let items):
                        DispatchQueue.main.async {
                            self.latestItems = items
                        }
                }
            }
            
            // Fetch all Items
            API.items(jellyfin) { (result) in
                switch result {
                    case .failure(let error):
                        API.logError(method: .items, error: error, session: session, in: .watchNow)
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items", error)
                    case .success(let items):
                        DispatchQueue.main.async {
                            self.items = items
                        }
                }
            }
        }
    }
    
    struct WatchNowView_Previews: PreviewProvider
    {
        static var previews: some View
        {
            WatchNowView()
        }
    }
}
