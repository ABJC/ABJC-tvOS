/*
 ABJC - tvOS
 ServerDiscovery.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

public class ServerDiscovery {
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
            hasher.combine(id)
        }

        public var address: String
        public let id: String
        public let name: String

        public var url: URL {
            URL(string: address)!
        }

        public var scheme: String {
            let components = URLComponents(string: address)
            return components?.scheme ?? "https"
        }

        public var host: String {
            let components = URLComponents(string: address)
            if let host = components?.host {
                return host
            }
            return address
        }

        public var port: Int {
            let components = URLComponents(string: address)
            if let port = components?.port {
                return port
            }
            return 8096
        }

        enum CodingKeys: String, CodingKey {
            case address = "Address"
            case id = "Id"
            case name = "Name"
        }
    }

    private let broadcastConn: UDPBroadcastConnection

    public init() {
        func receiveHandler(_: String, _: Int, _: Data) {}

        func errorHandler(error _: UDPBroadcastConnection.ConnectionError) {}

        broadcastConn = try! UDPBroadcastConnection(port: 7359, handler: receiveHandler, errorHandler: errorHandler)
    }

    public func locateServer(completion: @escaping (ServerLookupResponse?) -> Void) {
        func receiveHandler(_ address: String, _: Int, _ data: Data) {
            do {
                var response = try JSONDecoder().decode(ServerLookupResponse.self, from: data)
                print(response.address, address)
                // Replace Address in Object with actual address (fixes docker not working)

                // If Address is already correct: return | else: replace
                if response.address.contains(address) {
                    completion(response)
                    return
                }

                guard let regex = try? NSRegularExpression(
                    pattern: "([0-9]{1,3}\\.){3}[0-9]{1,3}",
                    options: .caseInsensitive
                ) else {
                    print("Failed to replace Address")
                    completion(response)
                    return
                }
                let range = NSMakeRange(0, response.address.count)
                let newAddress = regex.stringByReplacingMatches(
                    in: response.address,
                    options: [],
                    range: range,
                    withTemplate: address
                )

                response.address = newAddress
                completion(response)
            } catch {
                completion(nil)
            }
        }
        broadcastConn.handler = receiveHandler
        do {
            try broadcastConn.sendBroadcast("Who is JellyfinServer?")
//            LogManager.shared.log.debug("Discovery broadcast sent", tag: "ServerDiscovery")
        } catch {
            print(error)
        }
    }
}
