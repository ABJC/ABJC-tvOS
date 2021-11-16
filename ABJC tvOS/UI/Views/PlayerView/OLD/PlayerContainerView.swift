/*
 ABJC - tvOS
 PlayerContainerView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import SwiftUI
import TVVLCKit

struct PlayerContainerView: SwiftUI.View {
    @EnvironmentObject var store: PlayerViewDelegate

    var body: some SwiftUI.View {
        Text("NOT IMPLEMENTED (DEPRACATED)")
//        ZStack(alignment: .bottom) {
//            Color.black
//            PlayerView()
//                .environmentObject(store)
//                .focusable()
//                .onPlayPauseCommand(perform: store.playPause)
//                .onMoveCommand(perform: store.onMoveCommand)
        ////                .onSwipeLeft(store.quickSeekForward)
        ////                .onSwipeRight(store.quickSeekBackward)
        ////                .onSwipeUp { store.showsControlls = true }
        ////                .onSwipeDown { store.showsControlls = false }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .accessibilityIdentifier("playerView")
//        .onAppear(perform: store.onAppear)
//        .onDisappear(perform: store.onDisappear)
//        .fullScreenCover(isPresented: $store.showsControlls, onDismiss: {
//            print("HIDDEN")
//        }, content: {
//            PlayerControllsView(store: store)
//        })
    }
}

// struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView(store: .init(.preview))
//    }
// }
