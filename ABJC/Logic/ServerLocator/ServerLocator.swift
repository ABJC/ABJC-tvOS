//
//  ServerLocator.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

public class ServerLocator {
    public struct ServerCredential: Codable {
        public let host: String
        public let port: Int
        public let username: String
        public let password: String
        public let deviceId: String
        
        public init(_ host: String, _ port: Int, _ username: String, _ password: String, _ deviceId: String = UUID().uuidString) {
            self.host = host
            self.port = port
            self.username = username
            self.password = password
            self.deviceId = deviceId
        }
    }
    
    public struct ServerLookupResponse: Codable, Hashable, Identifiable {
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        private let address: String
        public let id: String
        public let name: String
        
        public var url: URL {
            URL(string: self.address)!
        }
        public var host: String {
            let components = URLComponents(string: self.address)
            return components!.host!
        }
        
        public var port: Int {
            let components = URLComponents(string: self.address)
            return components!.port!
        }
        
        enum CodingKeys: String, CodingKey {
            case address = "Address"
            case id = "Id"
            case name = "Name"
        }
    }
    private let broadcastConn: UDPBroadcastConnection
    
    public init() {
        func receiveHandler(_ ipAddress: String, _ port: Int, _ response: Data) {
            print("RECIEVED \(ipAddress):\(String(port)) \(response)")
        }
        
        func errorHandler(error: UDPBroadcastConnection.ConnectionError) {
            print(error)
        }
        self.broadcastConn = try! UDPBroadcastConnection(port: 7359, handler: receiveHandler, errorHandler: errorHandler)
    }
    
    public func locateServer(completion: @escaping (ServerLookupResponse?) -> Void) {
        func receiveHandler(_ ipAddress: String, _ port: Int, _ data: Data) {
            do {
                let response = try JSONDecoder().decode(ServerLookupResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }
        }
        self.broadcastConn.handler = receiveHandler
        do {
            try broadcastConn.sendBroadcast("Who is JellyfinServer?")
        } catch {
            print(error)
        }
    }
}
