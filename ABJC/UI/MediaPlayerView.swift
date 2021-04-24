//
//  MediaPlayerView.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI
import AVKit



struct MediaPlayerView: View {
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    @State var player: AVPlayer = AVPlayer()
    @State var playerReady: Bool = false
    @StateObject var playstate: Playstate = Playstate()
    
    let item: APIModels.MediaItem
    
    var isPausedObserver = 0
    
    @State var detailItem: PlayableMediaItem? = nil
    
    public init(_ item: APIModels.MediaItem) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            Blur().edgesIgnoringSafeArea(.all)
            VideoPlayer(player: self.player)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: load)
        .onDisappear(perform: deinitPlayback)
    }
    
    func load() {
        if item.type == .movie {
            API.movie(session.jellyfin!, item.id) { result in
                switch result {
                    case .success(let item):
                        self.detailItem = item
                        initPlayback()
                    case .failure(let error):
                        session.setAlert(.api, "Failed to fetch item detail", "getMovie failed", error)
                }
            }
        } else {
            fatalError("Episode & Series Playback not yet implemented")
        }
        
    }
    
    /// Initializes the Player
    func initPlayback() {
        guard let playItem = detailItem else {
            fatalError("Detail Item nil")
        }
        
        guard let mediaSourceId = playItem.mediaSources.first?.id else {
            fatalError("Couldn't find suitable Stream")
        }
        
        let asset = API.playerItem(session.jellyfin!, playItem, mediaSourceId)
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                
        // Configure Playstate
        self.playstate.setPlayer(player)
                
        // Report Playback Progress back to Jellyfin Server
        self.playstate.startObserving() { event, state in
            API.reportPlaystate(session.jellyfin!, .progress, playItem.id, mediaSourceId, self.playstate)
        }
        
        player.play()
        API.reportPlaystate(session.jellyfin!, .started, playItem.id, mediaSourceId, self.playstate)
        
        self.playerReady = true
        
//
//        print("USERDATA", playItem.userData.playbackPosition, playItem.userData.playbackPositionTicks, playItem.userData.playbackPositionTicks/playItem.userData.playbackPosition)
//        player.seek(to: CMTime(seconds: Double(playItem.userData.playbackPosition), preferredTimescale: 1))
    }
    
    func deinitPlayback() {
        self.player.pause()
        guard let playItem = detailItem else {
            fatalError("Detail Item nil")
        }
        
        guard let mediaSourceId = playItem.mediaSources.first?.id else {
            fatalError("Couldn't find suitable Stream")
        }
        
        self.playstate.stopObserving()
        API.reportPlaystate(session.jellyfin!, .stopped, playItem.id, mediaSourceId, self.playstate)
    }
}

//struct MediaPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediaPlayerView()
//    }
//}
