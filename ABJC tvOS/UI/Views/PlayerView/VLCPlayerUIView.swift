/*
 ABJC - tvOS
 VLCPlayerUIView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI
import TVVLCKit

class VLCPlayerUIView: UIView, VLCMediaPlayerDelegate {
    var store: PlayerViewDelegate!

    public var mediaPlayer: VLCMediaPlayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func initialize(with store: PlayerViewDelegate) {
        self.store = store
        mediaPlayer = self.store.player
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self
    }

    public func play(url: URL) {
        mediaPlayer.media = VLCMedia(url: url)
        mediaPlayer.play()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
