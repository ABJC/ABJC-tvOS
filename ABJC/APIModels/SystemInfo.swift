//
//  SystemInfo.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    public struct SystemInfo: Codable {
        public let serverName: String
        public let serverId: String
        
        private let address: String
        
        public var host: String {
            return URL(string: address)!.host ?? "ERROR"
        }
        
        public var port: Int {
            return URL(string: address)!.port ?? 0
        }
        
        public let version: String
        
        
        
        public let operatingSystemName: String
        public let operatingSystem: String
        public let systemArchitecture: String
        
        public let hasUpdateAvailable: Bool
        
        
        enum CodingKeys: String, CodingKey {
            case serverName = "ServerName"
            case serverId = "Id"
            case address = "LocalAddress"
            case version = "Version"
            
            case operatingSystemName = "OperatingSystemDisplayName"
            case operatingSystem = "OperatingSystem"
            case systemArchitecture = "SystemArchitecture"
            
            case hasUpdateAvailable = "HasUpdateAvailable"
        }
        
    }
}
