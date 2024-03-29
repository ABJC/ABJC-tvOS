/*
 ABJC - tvOS
 Jellyfin.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI
import SwiftUI

class Jellyfin {
    struct Server {
        var id: String
        var name: String
        var scheme: String
        var host: String
        var port: Int
        var path: String

        var baseURI: String {
            "\(scheme)//\(host):\(port)/\(path)"
        }

        init(discovered server: ServerDiscovery.ServerLookupResponse) {
            id = server.id
            name = server.name
            scheme = server.scheme
            host = server.host
            port = server.port
            path = server.url.path
        }

//        init(host: String, port: Int, isHttps: Bool) {
//            self.host = host
//            self.port = port
//            self.
//        }
    }

    class Credentials: ObservableObject {
        static var staticDeviceId: String = "tvOS_\(UIDevice.current.identifierForVendor!.uuidString)"

        let userId: String
        let deviceId: String
        let accessToken: String

        init(userId: String, accessToken: String) {
            self.userId = userId
            self.accessToken = accessToken
            deviceId = Self.staticDeviceId
        }

        init(userId: String, accessToken: String, deviceId: String) {
            self.userId = userId
            self.accessToken = accessToken
            self.deviceId = deviceId
        }

        convenience init(_ result: AuthenticationResult) {
            self.init(userId: result.user!.id!, accessToken: result.accessToken!)
        }
    }
}
