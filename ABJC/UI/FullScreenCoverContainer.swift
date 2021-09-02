//
//  FullScreenCoverContainer.swift
//  FullScreenCoverContainer
//
//  Created by Noah Kamara on 02.09.21.
//

import SwiftUI

struct FullScreenCoverContainer: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        ZStack {
            if let focusItem = session.itemFocus {
                LibraryView.ItemPage(focusItem)
                    .environmentObject(session)
            }
            
            if let playItem = session.itemPlaying {
                MediaPlayerView(playItem)
                    .environmentObject(session)
            }
        }
    }
}

struct FullScreenCoverContainer_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverContainer()
    }
}
