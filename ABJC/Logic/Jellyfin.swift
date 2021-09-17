//
//  JellyfinUser.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

public class Jellyfin: Codable {
    private(set) public var server: Server
    private(set) public var user: User
    private(set) public var client: Client
    
    public init(_ server: Server, _ user: User, _ client: Client) {
        self.server = server
        self.user = user
        self.client = client
    }
}

extension Jellyfin {
    public class User: Codable {
        private(set) public var userId: String
        private(set) public var serverId: String
        private(set) public var accessToken: String
        
        public init(_ userId: String, _ serverId: String, _ accessToken: String) {
            self.userId = userId
            self.serverId = serverId
            self.accessToken = accessToken
        }
    }
}


extension Jellyfin {
    public class Server: Codable {
        private(set) public var host: String
        private(set) public var port: Int
        private(set) public var https: Bool
        private(set) public var path: String?
        
        public init(_ host: String, _ port: Int, _ https: Bool = false, _ path: String? = nil) {
            self.host = host
            self.port = port
            self.https = https
            self.path = path
        }
    }
}

extension Jellyfin {
    public class Client: Codable {
        private(set) public var deviceId: String
        
        public init(_ deviceId: String) {
            self.deviceId = deviceId
        }
        
        public init() {
            self.deviceId = UUID().uuidString
        }
    }
}

extension Jellyfin {
    
    /// Remove the user from the Jellyfin Instance
    public func resetUser(){
        user = User("", "", "")
    }
    
    /// Check if there is a valid User instance
    /// - Returns: return true if User is valid
    public func isUserLoggedIn() -> Bool{
        return user.userId != ""
    }
}
