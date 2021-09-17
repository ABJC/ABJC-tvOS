//
//  UserData.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import Foundation

extension APIModels {
    struct UserData: Codable {
        public let playbackPositionTicks: Int
        public var playbackPosition: Int {
            return Int(playbackPositionTicks/10000000)
        }
        public let playCount: Int
        public let isFavorite: Bool
        public let played: Bool
        public let key: String
        
        enum CodingKeys: String, CodingKey {
            case playbackPositionTicks = "PlaybackPositionTicks"
            case playCount = "PlayCount"
            case isFavorite = "IsFavorite"
            case played = "Played"
            case key = "Key"
        }
    }
}
