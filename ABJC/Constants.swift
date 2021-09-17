//
//  Constants.swift
//  Constants
//
//  Created by Noah Kamara on 03.09.21.
//

import Foundation

struct Constants: Codable {
    public let analytics_key: String
    private let analytics_host: String
    private let analytics_port: Int
    
    public var analytics_url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = analytics_host
        components.port = analytics_port
        components.path = "/event"
        return components.url!
    }
    
    enum CodingKeys: String, CodingKey {
        case analytics_key = "analytics-key"
        case analytics_host = "analytics-host"
        case analytics_port = "analytics-port"
    }
    
    static var `default`: Self {
        return Constants(analytics_key: "", analytics_host: "localhost", analytics_port: 8080)
    }
    
    static var load: Self {
        if  let path        = Bundle.main.path(forResource: "Constants", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let constants = try? PropertyListDecoder().decode(Constants.self, from: xml)
        {
            print("CONSTANTS: key='\(constants.analytics_key)'")
            return constants
        } else {
            fatalError("Couldn't read PLIST")
            return Constants.default
        }
    }
}

