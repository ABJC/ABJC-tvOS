//
//  PlaybackError.swift
//  ABJC
//
//  Created by Noah Kamara on 08.12.21.
//

import Foundation
import TVVLCKit
import AnyCodable
import JellyfinAPI

struct PlaybackError: Encodable {
    var player: [String: AnyEncodable]
    var type: PlaybackErrorType
    
    init(detail: PlaybackErrorType, _ player: VLCMediaPlayer) {
        self.type = detail
        self.player = player.analyticsData
    }
}


enum PlaybackErrorType: String, Encodable {
    case player
    case initialization
}
