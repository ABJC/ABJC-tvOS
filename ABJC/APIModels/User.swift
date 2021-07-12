//
//  User.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    public struct User: Decodable, Identifiable {
        public let id: String
        public let name: String
        public let serverID: String
        
        public let hasPassword: Bool
        public let hasConfiguredPassword: Bool
        public let hasConfiguredEasyPassword: Bool
        public var enableAutoLogin: Bool? = true
        public let lastLoginDate: String
        public let lastActivityDate: String
        public let primaryImageTag: String?
        
        //        public let configuration: Configuration
        //        public let policy: Policy
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case serverID = "ServerId"
            case id = "Id"
            case hasPassword = "HasPassword"
            case hasConfiguredPassword = "HasConfiguredPassword"
            case hasConfiguredEasyPassword = "HasConfiguredEasyPassword"
            case enableAutoLogin = "EnableAutoLogin"
            case lastLoginDate = "LastLoginDate"
            case lastActivityDate = "LastActivityDate"
            case primaryImageTag = "PrimaryImageTag"
            //            case configuration = "Configuration"
            //            case policy = "Policy"
        }
    }
}
