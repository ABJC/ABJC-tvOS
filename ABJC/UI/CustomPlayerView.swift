//
//  CustomPlayerView.swift
//  ABJC
//
//  Created by Stephen Byatt on 18/5/21.
//

import SwiftUI
import AVKit
import TVUIKit
import os

struct AVPlayerView: UIViewControllerRepresentable {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PLAYER")
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    @State var playerReady: Bool = false
    @StateObject var playstate: Playstate = Playstate()
    
    var isPausedObserver = 0
    
    let item: PlayItem
    
    public init(_ item: PlayItem) {
        self.item = item
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        
        
        self.logger.info("Initializing Playback")
        
        guard let mediaSourceId = self.item.mediaSources.first?.id else {
            self.logger.error("Failed to find suitable media source")
            fatalError("Couldn't find suitable Stream")
        }
        
        let asset = API.playerItem(session.jellyfin!, self.item, mediaSourceId)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                
        // Configure Playstate
        self.playstate.setPlayer(player)
                
        // Report Playback Progress back to Jellyfin Server
        self.logger.info("Initializing Playstate Observers")
        self.playstate.startObserving() { event, state in
            API.reportPlaystate(session.jellyfin!, .progress, self.item.id, mediaSourceId, self.playstate)
        }
        
        self.logger.info("Playing")
//        player.play()
        API.reportPlaystate(session.jellyfin!, .started, self.item.id, mediaSourceId, self.playstate)
        
        self.playerReady = true
        
        
        playerController.player = player
        playerController.player?.play()
//        playerController.customInfoViewController = custom
        return playerController
    }
    
    
}
