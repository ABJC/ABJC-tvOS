//
//  Playstate.swift
//  ABJC
//
//  Created by Noah Kamara on 22.04.21.
//

import Foundation
import AVKit


class Playstate: NSObject, ObservableObject {
    private let ticksPerSecond = 10000000
    private var reportHandler: (APIModels.PlaystateReport.Event, Playstate) -> Void = { _, _ in print("REPORT PLAYBACK NOT")}
    
    @Published var position: Int = 0
    @Published var isPaused: Bool = false
    @Published var isMuted: Bool = false
    
    var observers: [Any] = []
    
    
    
    var player: AVPlayer!
    private var positionObserver: Any? = nil
    private var playerContext = 0
    
    var positionTicks: Int {
        return position * ticksPerSecond
    }
    
    func setPlayer(_ player: AVPlayer) {
        self.player = player
    }
    
    func startObserving(_ handler: @escaping (APIModels.PlaystateReport.Event, Playstate) -> Void) {
        // Set the report Handler
        self.reportHandler = handler
        
        let interval = CMTime(seconds: 10, preferredTimescale: CMTimeScale(ticksPerSecond))
        positionObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            self.position = Int(time.seconds)
            self.reportHandler(.progress, self)
        }
        
        // isPaused
        self.player.addObserver(self, forKeyPath: "timeControlStatus", options: [.new], context: &playerContext)
        
        // isMuted
        self.player.addObserver(self, forKeyPath: "isMuted", options: [.new], context: &playerContext)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard context == &playerContext else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
            return
        }
        
        DispatchQueue.main.async {
            switch keyPath {
                case "timeControlStatus":
                    self.isPaused = (self.player.timeControlStatus == .paused)
                case "isMuted":
                    self.isMuted = self.player.isMuted
                //                case "isMuted": self.isMuted = player.isMuted
                default: return
            }
        }
        self.reportHandler(.progress, self)
    }
    
    func stopObserving() {
        if let observer = positionObserver {
            self.player.removeTimeObserver(observer)
        }
    }
}
