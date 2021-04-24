//
//  Playstate.swift
//  ABJC
//
//  Created by Noah Kamara on 22.04.21.
//

import Foundation

extension APIModels
{
    public struct PlaystateReport: Codable {
        let canSeek: Bool = true
        
        var isPaused: Bool
        var isMuted: Bool
        
        var itemId: String
        var mediaSourceId: String
        var position: Int = 0
        
        init(_ itemId: String, _ mediaSourceId: String, _ state: Playstate) {
            self.itemId = itemId
            self.mediaSourceId = mediaSourceId
            self.position = state.positionTicks
            self.isPaused = state.isPaused
            self.isMuted = state.isMuted
        }
        
        
        enum CodingKeys: String, CodingKey {
            case itemId = "ItemId"
            case mediaSourceId = "MediaSourceId"
            case position = "PositionTicks"
            case canSeek, isPaused, isMuted
        }
        
        public enum Event: String {
            case started = "started"
            case stopped = "stopped"
            case progress = "progress"
        }
    }
}
