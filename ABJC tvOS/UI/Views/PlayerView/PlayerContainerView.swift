//
//  PlayerView.swift
//  PlayerView
//
//  Created by Noah Kamara on 14.09.21.
//

import SwiftUI
import TVVLCKit

struct PlayerContainerView: SwiftUI.View {
    @EnvironmentObject
    var store: PlayerViewDelegate

    var body: some SwiftUI.View {
        //        VideoPlayer(player: store.player)
        ZStack(alignment: .bottom) {
            Blur()
            PlayerView().environmentObject(store)
            if store.showsControlls {
                PlayerControllsView()
                    .environmentObject(store)
                    .animation(.easeInOut, value: 0.5)
            }
        }
        .accessibilityIdentifier("playerView")
        .edgesIgnoringSafeArea(.all)
        .focusable()
        .onPlayPauseCommand(perform: store.playPause)
        .onMoveCommand(perform: store.quickSeek)

        .onDisappear(perform: store.onDisappear)
    }
}

// struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView(store: .init(.preview))
//    }
// }
