//
//  PlayerViewDelegate.swift
//  PlayerViewDelegate
//
//  Created by Noah Kamara on 14.09.21.
//

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
    
    init(_ item: BaseItemDto) {
        self.item = item
        super.init()
        loadPlaybackInfo()
    }
    
    /// Load PlaybackInfo Response
    func loadPlaybackInfo() {
        playbackInfo = nil
        guard let userId = session.credentials?.userId,
              let itemId = item.id
        else {
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
        if let playbackInfo = self.playbackInfo {
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
                guard let credentials = session.credentials else {
                    return
                }
                var urlComponents = URLComponents(string: JellyfinAPI.basePath)!
                urlComponents.path = "/Videos/\(item.id!)/stream"
                urlComponents.queryItems = [
                    .init(name: "Static", value: "true"),
                    .init(name: "mediaSourceId", value: mediaSource.id!),
                    .init(name: "deviceId", value: credentials.deviceId),
                    .init(name: "api_key", value: credentials.accessToken),
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
    
    func quickSeek(_ direction: MoveCommandDirection) {
        //        print("MOVE \(String(describing: direction))")
        switch direction {
            case .up: showsControlls = true
            case .down: showsControlls = false
            case .left: player.jumpBackward(15)
            case .right: player.jumpForward(30)
            @unknown default: break
        }
    }
    
    /// Initialize Playback
    func initPlayback() {
        player.stop()
        guard let streamURL = streamURL else {
            return
        }
        player.media = .init(url: streamURL)
        player.play()
    }
}
