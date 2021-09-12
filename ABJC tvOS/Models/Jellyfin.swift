//
//  Jellyfin.swift
//  Jellyfin
//
//  Created by Noah Kamara on 09.09.21.
//

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
            return "\(scheme)//\(host):\(port)/\(path)"
        }
        
        init(discovered server: ServerDiscovery.ServerLookupResponse) {
            self.id = server.id
            self.name = server.name
            self.scheme = server.scheme
            self.host = server.host
            self.port = server.port
            self.path = server.url.path
        }
        
//        init(host: String, port: Int, isHttps: Bool) {
//            self.host = host
//            self.port = port
//            self.
//        }
    }
    
    class Credentials: ObservableObject {
        static var _deviceId: String = "tvOS_\(UIDevice.current.identifierForVendor!.uuidString)"
        
        let userId: String
        let deviceId: String
        let accessToken: String
        
        init(userId: String, accessToken: String) {
            self.userId = userId
            self.accessToken = accessToken
            self.deviceId = Self._deviceId
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

