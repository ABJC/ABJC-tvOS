//
//  Movie.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import Foundation

extension APIModels {
    struct Movie: Codable, PlayableMediaItem {
        public let id: String
        public let serverId: String?
        public let type: MediaType
        
        public let name: String
        public let originalTitle: String?
        public let sortName: String?
        public let overview: String?
        public let year: Int?
        
        public let canDownload: Bool?
        public let hasSubtitles : Bool?
        
        public let people: [Person]?
        public let genres: [Genre]?
        public let mediaSources: [MediaSource]
        
        public let criticRating: Int?
        private let communityRating: Double
        
        public let userData: UserData
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case originalTitle = "OriginalTitle"
            case id = "Id"
            case serverId = "ServerId"
            case type = "Type"
            case canDownload = "CanDownload"
            case hasSubtitles = "HasSubtitles"
            case sortName = "SortName"
            case overview = "Overview"
            case year = "ProductionYear"
            case people = "People"
            case genres = "GenreItems"
            case mediaSources = "MediaSources"
            
            case criticRating = "CriticRating"
            case communityRating = "CommunityRating"
            
            case userData = "UserData"
        }
    }
}
