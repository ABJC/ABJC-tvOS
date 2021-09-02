//
//  Season.swift
//  ABJC
//
//  Created by Noah Kamara on 05.04.21.
//

import Foundation

extension APIModels
{
    public struct Season: Decodable, Hashable, Identifiable {
        public static func == (lhs: APIModels.Season, rhs: APIModels.Season) -> Bool {
            return lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        public let id: String
        public let serverId: String
        
        public let name: String
        
        public let rawIndex: Int?
        public var index: Int {
            return self.rawIndex ?? 0
        }
        public let seriesId: String
        public let seriesName: String
        
        public let userData: UserData?
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case serverId = "ServerId"
            case name = "Name"
            case rawIndex = "IndexNumber"
            case seriesId = "SeriesId"
            case seriesName = "SeriesName"
            
            case userData = "UserData"
        }
    }
}
