//
//  PlayerUIView.swift
//  PlayerUIView
//
//  Created by Noah Kamara on 14.09.21.
//

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
