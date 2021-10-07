/*
 ABJC - tvOS
 PlayerViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 07.10.21
 */

import Foundation
import JellyfinAPI
import MediaPlayer
import SwiftUI
import TVVLCKit

class PlayerViewDelegate: ViewDelegate {
    let player: VLCMediaPlayer = .init()

    // Playback Item Objects
    public let item: BaseItemDto
    @Published
    var playbackInfo: PlaybackInfoResponse?
    @Published
    var streamURL: URL?

    // Controlls State
    @Published
    var showsControlls: Bool = true

    // VideoPlayer States
    @Published
    var time: Int = 0
    @Published
    var timeRemaining: Int = 0
    @Published
    var state: VLCMediaPlayerState?

    // Tracks
    @Published
    var currentVideoTrack = Track(index: -99, name: "NO TRACK")
    @Published
    var currentAudioTrack = Track(index: -99, name: "NO TRACK")

    init(_ item: BaseItemDto) {
        self.item = item
        super.init()
        loadPlaybackInfo()
    }

    /// Load PlaybackInfo Response
    func loadPlaybackInfo() {
        playbackInfo = nil
        guard let userId = session.user?.id,
              let itemId = item.id else {
            return
        }
        MediaInfoAPI.getPlaybackInfo(itemId: itemId, userId: userId) { result in
            switch result {
                case let .success(response):
                    self.playbackInfo = response
                    self.loadStreamURL()
                case let .failure(error):
                    self.handleApiError(error)
            }
        }
    }

    /// Load StreamURL
    func loadStreamURL() {
        if let playbackInfo = playbackInfo {
            guard let mediaSource = playbackInfo.mediaSources?.first else {
                return
            }
            var streamURL: URL!

            // Item will be transcoded
            if let transcodiungUrl = mediaSource.transcodingUrl {
                streamURL = URL(string: "\(JellyfinAPI.basePath)\(transcodiungUrl)")!
            }
            // Item will be directly played by the client
            else {
                guard let user = session.user else {
                    return
                }
                var urlComponents = URLComponents(string: JellyfinAPI.basePath)!
                urlComponents.path = "/Videos/\(item.id!)/stream"
                urlComponents.queryItems = [
                    .init(name: "Static", value: "true"),
                    .init(name: "mediaSourceId", value: mediaSource.id!),
                    .init(name: "deviceId", value: user.deviceId),
                    .init(name: "api_key", value: user.token),
                    .init(name: "Tag", value: mediaSource.eTag!)
                ]
                guard let url = urlComponents.url else {
                    return
                }
                streamURL = url
            }
            self.streamURL = streamURL
        }
    }

    func onAppear() {
        player.play()
        showsControlls = true
    }

    func onDisappear() {
        player.stop()
    }

    func playPause() {
        //        print("PLAY/PAUSE")
        if player.isPlaying {
            player.pause()
            showsControlls = true
        } else {
            player.play()
        }
    }

    func quickSeekForward() {
        showsControlls = true
        player.jumpForward(30)
    }

    func quickSeekBackward() {
        showsControlls = true
        player.jumpBackward(15)
    }

    func onMoveCommand(_ direction: MoveCommandDirection) {
        showsControlls = true
        print("MOVED")

        if direction != .down {
            showsControlls = true
        }
        switch direction {
            case .up: break
            case .down: showsControlls = false
            case .left: quickSeekBackward()
            case .right: quickSeekForward()
            @unknown default: break
        }
    }

    /// Initialize Playback
    func initPlayback() {
        player.stop()
        player.setDeinterlaceFilter(nil)
        guard let streamURL = streamURL else {
            return
        }
        player.media = .init(url: streamURL)
    }
}
