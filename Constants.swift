//
//  Constants.swift
//  Constants
//
//  Created by Noah Kamara on 14.09.21.
//

import Foundation

public struct Constants: Codable {
    var users: [String: Credentials]
    var server: Server
    var analytics: AnalyticsInfo

    var serverURI: String { server.uri }

    static func with(bundle: Bundle) -> Constants? {
        guard let path = bundle.path(forResource: "Constants", ofType: "plist") else {
            return nil
        }

        guard let xml = FileManager.default.contents(atPath: path) else {
            return nil
        }

        do {
            let constants = try PropertyListDecoder().decode(Constants.self, from: xml)
            return constants
        } catch {
            print("ERROR", error)
            return nil
        }
    }

    static var current: Constants? {
        return with(bundle: .main)
    }
}

extension Constants {
    struct Credentials: Codable {
        var password: String?
        var username: String
    }
}

extension Constants {
    struct Server: Codable {
        var scheme: String
        var host: String
        var port: String
        var path: String

        var uri: String {
            return scheme + "://" + host + ":" + port + path
        }
    }
}

extension Constants {
    struct AnalyticsInfo: Codable {
        var uri: String
        var key: String
    }
}
