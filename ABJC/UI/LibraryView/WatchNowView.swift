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
                    VStack(alignment: .leading) {
                        CoverRowView(latestItems)
                        
                        if let items = items {
                            GroupingViewContainer(items).environmentObject(session)
                        }
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }
            .onAppear(perform: load)
        }
        
        func load() {
            API.latest(session.jellyfin!) { (result) in
                switch result {
                    case .failure(let error):
                        session.setAlert(.api, "Couldn't fetch Items", "Couldn't fetch Items (latest)", error)
                    case .success(let items):
                        DispatchQueue.main.async {
                            self.latestItems = items
                        }
                }
            }
            
            API.items(session.jellyfin!) { (result) in
                switch result {
                    case .failure(let error):
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
