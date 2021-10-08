/*
 ABJC - tvOS
 PlayerDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import Foundation
import JellyfinAPI
import TVVLCKit

enum PlaybackError: Error {
    case unknown(String)
}

class PlayerDelegate: ViewDelegate {
    let item: BaseItemDto
    let player: VLCMediaPlayer = .init()

    init(_ item: BaseItemDto) {
        self.item = item

        super.init()

        initPlayback()
    }

    @Published var isReadyToPlay: Bool = false
    @Published var isShowingInterface: Bool = false

    @Published var playerState: VLCMediaPlayerState = .stopped
    @Published var playerTime: VLCTime = .init(int: 0)
    @Published var playerTimeRemaining: VLCTime = .init(int: 0)

    @Published var videoTracks: [Track] = []
    @Published var audioTracks: [Track] = []

    @Published var currentVideoTrack: Track?
    @Published var currentAudioTrack: Track?

    func initPlayback() {
        loadPlaybackInfo { result in
            switch result {
                case let .failure(error):
                    self.handleApiError(error)
                case let .success(info):
                    let streamURL = self.loadStreamURL(info)
                    guard let streamURL = streamURL else {
                        return
                    }

                    self.player.media = .init(url: streamURL)
                    self.isReadyToPlay = true

                    print("WILLPLAY", self.player.willPlay)
                    self.player.play()
            }
        }
    }

    func loadPlaybackInfo(_ completion: @escaping ((Result<PlaybackInfoResponse, Error>) -> Void)) {
        guard let userId = session.user?.id, let itemId = item.id else {
            fatalError("User is not authenticated")
            return
        }
        MediaInfoAPI.getPlaybackInfo(itemId: itemId, userId: userId) { result in
            completion(result)
        }
    }

    func loadStreamURL(_ playbackInfo: PlaybackInfoResponse) -> URL? {
        guard let mediaSource = playbackInfo.mediaSources?.first else {
            return nil
        }

        // Item will be transcoded
        if let transcodiungUrl = mediaSource.transcodingUrl {
            return URL(string: "\(JellyfinAPI.basePath)\(transcodiungUrl)")!
        }
        // Item will be directly played by the client
        else {
            guard let user = session.user else {
                return nil
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
                return nil
            }
            return url
        }
    }

    func playerStateChanged(_ player: VLCMediaPlayer) {
        session.logger.log.debug("Player - StateChanged: \(player.state.debugDescription)", tag: "PLAYER")
        playerState = player.state

        // Update Tracks Information
        videoTracks = player.videoTracks
        audioTracks = player.audioTracks
        currentVideoTrack = player.currentVideoTrack
        currentAudioTrack = player.currentAudioTrack
    }

    func playerTimeChanged(_ player: VLCMediaPlayer) {
//        session.logger.log.debug("Player - TimeChanged: \(String(describing: player.time.stringValue))", tag: "PLAYER")
        playerTime = player.time
        playerTimeRemaining = player.remainingTime
    }

    func mediaDidFinishParsing(_ media: VLCMedia) {
        session.logger.log.debug("Media - DidFinishParsing: \(media.url)", tag: "PLAYER")
        videoTracks = player.videoTracks
        audioTracks = player.audioTracks
        currentVideoTrack = player.currentVideoTrack
        currentAudioTrack = player.currentAudioTrack
    }
}
