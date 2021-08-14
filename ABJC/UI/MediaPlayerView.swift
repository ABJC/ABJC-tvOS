//
//  MediaPlayerView.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI
import AVKit
import os


struct MediaPlayerView: View {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PLAYER")
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    @State var player: AVPlayer = AVPlayer()
    @State var playerReady: Bool = false
    @StateObject var playstate: Playstate = Playstate()
    
    let item: PlayItem
    
    public init(_ item: PlayItem) {
        print("INITIALIZING")
        self.item = item
    }
    
    
    var body: some View {
        VideoPlayer(player: self.player)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: initPlayback)
        .onDisappear(perform: deinitPlayback)
    }
    
    
    /// Initializes the Player
    func initPlayback() {
        self.logger.info("Initializing Playback")
        
        guard let jellyfin = session.jellyfin else {
            session.itemPlaying = nil
            session.logout()
            return
        }
        guard let mediaSourceId = self.item.mediaSources.first(where: { $0.canPlay })?.id else {
            self.logger.error("Failed to find suitable media source")
            fatalError("Couldn't find suitable Stream")
        }
        
        
        guard let asset = API.playerItem(jellyfin, self.item, mediaSourceId) else {
            self.logger.error("Couldn't get AVAsset")
            return
        }
        
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                
        // Configure Playstate
        self.playstate.setPlayer(player)
                
        // Report Playback Progress back to Jellyfin Server
        self.logger.info("Initializing Playstate Observers")
        self.playstate.startObserving() { event, state in
            API.reportPlaystate(jellyfin, .progress, self.item.id, mediaSourceId, self.playstate)
        }
        
        self.logger.info("Playing")
        player.play()
        API.reportPlaystate(jellyfin, .started, self.item.id, mediaSourceId, self.playstate)
        
        self.playerReady = true
        
//
//        print("USERDATA", self.item.userData.playbackPosition, self.item.userData.playbackPositionTicks, self.item.userData.playbackPositionTicks/self.item.userData.playbackPosition)
//        player.seek(to: CMTime(seconds: Double(self.item.userData.playbackPosition), preferredTimescale: 1))
    }
    
    func deinitPlayback() {
        guard let jellyfin = session.jellyfin else {
            session.logout()
            return
        }
        
        self.logger.info("Deinitializing Playback")
        self.player.pause()
        
        guard let mediaSourceId = self.item.mediaSources.first?.id else {
            fatalError("Couldn't find suitable Stream")
        }
        
        self.logger.info("Removing Playstate Observers")
        self.playstate.stopObserving()
        API.reportPlaystate(jellyfin, .stopped, self.item.id, mediaSourceId, self.playstate)
    }
}

//struct MediaPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediaPlayerView()
//    }
//}
