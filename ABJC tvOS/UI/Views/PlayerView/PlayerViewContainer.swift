/*
 ABJC - tvOS
 PlayerViewContainer.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import AVKit
import SwiftUI

struct PlayerViewContainer: View {
    @Namespace var namespace
    @StateObject var store: PlayerDelegate

    var body: some View {
        ZStack {
            Color.green
            if store.isReadyToPlay {
                PlayerUIView(store: store)
                    .focusable()
                    .onLongPressGesture(minimumDuration: 0.01, perform: store.playPauseAction, onPressingChanged: { _ in })
                    .onPlayPauseCommand(perform: store.playPauseAction)
                    .onMoveCommand(perform: store.moveCommandAction)
                    .onSwipeRight(store.quickSeekForward)
                    .onSwipeLeft(store.quickSeekBackward)
                    .onSwipeUp { store.isShowingInterface = true }
                    .onSwipeDown { store.isShowingInterface = true }
            } else {
                ProgressView()
            }
        }
        .frame(width: 1920, height: 1080, alignment: .center)
        .fullScreenCover(isPresented: $store.isShowingInterface) {
            print("Interface Dismissed")
        } content: {
            PlayerControllsView(store: store)
        }
        .onDisappear {
            store.deinitPlayback()
        }
    }
}

// struct PlayerViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerViewContainer(store: .init(.preview))
//    }
// }
