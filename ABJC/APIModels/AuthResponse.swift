//
//  AuthResponse.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    public struct AuthResponse: Decodable {
        public let user: User
        public let accessToken: String
        public let serverId: String
        
        enum CodingKeys: String, CodingKey {
            case user = "User"
            case accessToken = "AccessToken"
            case serverId = "ServerId"
        }
    }
}
