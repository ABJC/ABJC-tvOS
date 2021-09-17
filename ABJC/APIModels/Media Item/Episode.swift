//
//  Episode.swift
//  ABJC
//
//  Created by Noah Kamara on 05.04.21.
//

import Foundation

extension APIModels {
    public struct Episode: Decodable, Hashable, Equatable, Identifiable, Playable {
        
        static public func == (_ rhs: Episode, _ lhs: Episode) -> Bool {
            return rhs.id == lhs.id
        }
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        public let id: String
        public let name: String
        public let type: MediaType
        
        public let seasonName: String
        public let seasonId: String
        public let index: Int?
        public let parentIndex: Int
        
        public let overview: String?
        
        public let genres: [Genre]?
        public let mediaSources: [MediaSource]
        
        
        private var imageBlurHashes: [String: [String: String]]?
        
        public func blurHash(for imageType: ImageType) -> String? {
            guard let hashes = imageBlurHashes else { return nil }
            return hashes[imageType.rawValue]?.values.first
        }
        
        private let communityRatingRaw: Double?
        public var communityRating: Int? {
            if let raw = communityRatingRaw {
                return Int(round(raw*10))
            } else {
                return nil
            }
        }
        
        public let userData: UserData
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case id = "Id"
            case type = "Type"
            case seasonName = "SeasonName"
            case seasonId = "SeasonId"
            case index = "IndexNumber"
            case parentIndex = "ParentIndexNumber"
            case mediaSources = "MediaSources"
            
            case imageBlurHashes = "ImageBlurHashes"
            case overview = "Overview"
            case genres = "GenreItems"
            case communityRatingRaw = "CommunityRating"
            case userData = "UserData"
        }
    }
}
