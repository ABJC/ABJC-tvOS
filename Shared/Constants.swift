/*
 ABJC - tvOS
 Constants.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10.10.21
 */

import Foundation

public struct Constants: Codable {
    var users: [String: Credentials]
    var server: Server
    var analytics: AnalyticsInfo

    var serverURI: String { server.uri }

    static func with(bundle: Bundle) -> Constants? {
        if let constants = fromCommandLine() {
            print("WARNING: using constants from command line")
            return constants
        }
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

    static func fromCommandLine() -> Constants? {
        CommandLineArguments().constants
    }

    static var current: Constants? {
        with(bundle: .main)
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
            scheme + "://" + host + ":" + port + path
        }
    }
}

extension Constants {
    struct AnalyticsInfo: Codable {
        var uri: String
        var key: String
    }
}
