/*
 ABJC - tvOS
 PlayerView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import JellyfinAPI
import SwiftUI
import TVVLCKit

struct PlayerView: UIViewRepresentable {
    @EnvironmentObject var store: PlayerViewDelegate

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
        store.initPlayback()
        view.initialize(with: store)
        view.mediaPlayer.delegate = context.coordinator
        view.mediaPlayer.media.delegate = context.coordinator
        return view
    }
}

extension PlayerView {
    class Coordinator: NSObject, VLCLibraryLogReceiverProtocol, VLCMediaPlayerDelegate, VLCMediaDelegate {
        var parent: PlayerView

        init(_ parent: PlayerView) {
            self.parent = parent
        }

        func handleMessage(_ message: String, debugLevel level: Int32) {
            print("VLC LOG", level, message)
        }

        func mediaDidFinishParsing(_: VLCMedia) {
            if let videoTrack = parent.store.player.currentVideoTrack {
                DispatchQueue.main.async {
                    self.parent.store.currentVideoTrack = videoTrack
                }
            }

            if let audioTrack = parent.store.player.currentAudioTrack {
                DispatchQueue.main.async {
                    self.parent.store.currentAudioTrack = audioTrack
                }
            }
        }

        func mediaPlayerStateChanged(_ aNotification: Notification!) {
            guard let player = aNotification.object as? VLCMediaPlayer else {
                return
            }
            parent.store.state = player.state
            print("STATE", player.state.debugDescription)

            switch player.state {
                case .error:
                    parent.store.session.app.analytics.send(.playbackError(player))
                case .playing:
                    parent.store.showsControlls = false
                default: break
            }
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
