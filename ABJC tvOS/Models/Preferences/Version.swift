//
//  Version.swift
//  Version
//
//  Created by Noah Kamara on 10.09.21.
//

import Foundation
import AnyCodable

/// Representation of a Version
public struct Version {
    public var description: String {
        if isTestFlight {
            return "[BETA] \(major).\(minor).\(patch) (\(build!))"
        } else {
            return "\(major).\(minor).\(patch)"
        }
    }
    
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let build: Int?
    
    public var isTestFlight: Bool {
        return build != nil
    }
    
    public init() {
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
        let buildString = Bundle.main.infoDictionary!["CFBundleVersion"]! as! String
        
        let versionArray = versionString.split(separator: ".")
        
        self.major = versionArray.count > 0 ? (Int(versionArray[0]) ?? 0) : 0
        self.minor = versionArray.count > 1 ? (Int(versionArray[1]) ?? 0) : 0
        self.patch = versionArray.count > 2 ? (Int(versionArray[2]) ?? 0) : 0
        
        self.build = Int(buildString) ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case major, minor, patch, build
        case description = "version"
    }
}
