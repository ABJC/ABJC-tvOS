/*
 ABJC - tvOS
 PlayerUIView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import SwiftUI
import TVVLCKit

struct PlayerUIView: UIViewRepresentable {
    @ObservedObject var store: PlayerDelegate

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_: VLCPlayerView, context _: Context) {}

    func makeUIView(context: Context) -> VLCPlayerView {
        let view = VLCPlayerView(frame: .zero)
        store.player.delegate = context.coordinator
        store.player.media.delegate = context.coordinator
        view.initialize(with: store)
        return view
    }
}

// VLCLibraryLogReceiverProtocol, VLCMediaPlayerDelegate, VLCMediaDelegate
extension PlayerUIView {
    class Coordinator: NSObject, VLCMediaPlayerDelegate, VLCMediaDelegate {
        private let parent: PlayerUIView

        init(_ parent: PlayerUIView) {
            self.parent = parent
        }

        func mediaPlayerStateChanged(_ aNotification: Notification!) {
            guard let vlcPlayer = aNotification.object as? VLCMediaPlayer else {
                return
            }
            parent.store.playerStateChanged(vlcPlayer)
        }

        func mediaPlayerTimeChanged(_ aNotification: Notification!) {
            guard let vlcPlayer = aNotification.object as? VLCMediaPlayer else {
                return
            }
            parent.store.playerTimeChanged(vlcPlayer)
        }

        func mediaPlayerChapterChanged(_: Notification!) {
            print("CHAPTER CHANGED")
        }

        func mediaDidFinishParsing(_ aMedia: VLCMedia) {
            parent.store.mediaDidFinishParsing(aMedia)
        }

        func mediaMetaDataDidChange(_ aMedia: VLCMedia) {
            print(aMedia.metaDictionary)
        }
    }
}

class VLCPlayerView: UIView, VLCMediaPlayerDelegate {
    var store: PlayerDelegate!

    public var mediaPlayer: VLCMediaPlayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func initialize(with store: PlayerDelegate) {
        self.store = store
        store.player.drawable = self
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
