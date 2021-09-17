/*
 ABJC - tvOS
 PlayerView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import JellyfinAPI
import SwiftUI
import TVVLCKit

struct PlayerView: UIViewRepresentable {
    @EnvironmentObject
    var store: PlayerViewDelegate

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_: VLCPlayerUIView, context _: Context) {
//        if !uiView.mediaPlayer.isPlaying,
//           let streamURL = store.streamURL {
//            uiView.play(url: streamURL)
//        }
    }

    func makeUIView(context: Context) -> VLCPlayerUIView {
        let view = VLCPlayerUIView(frame: .zero)
        view.initialize(with: store)
        view.mediaPlayer.delegate = context.coordinator
        return view
    }
}

extension PlayerView {
    class Coordinator: NSObject, VLCLibraryLogReceiverProtocol, VLCMediaPlayerDelegate {
        var parent: PlayerView

        init(_ parent: PlayerView) {
            self.parent = parent
        }

        func handleMessage(_ message: String, debugLevel level: Int32) {
            print("VLC LOG", level, message)
        }

        func mediaPlayerStateChanged(_ aNotification: Notification!) {
            guard let player = aNotification.object as? VLCMediaPlayer else {
                return
            }
            parent.store.state = player.state
        }

        func mediaPlayerTimeChanged(_ aNotification: Notification!) {
            guard let player = aNotification.object as? VLCMediaPlayer else {
                return
            }
            parent.store.time = Int(player.time.intValue)
            parent.store.timeRemaining = Int(player.remainingTime.intValue)
        }
    }
}

// struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
// }
