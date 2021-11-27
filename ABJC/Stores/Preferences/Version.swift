/*
 ABJC - tvOS
 Version.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import AnyCodable
import Foundation

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
        build != nil
    }

    public var tuple: (Int, Int, Int, Int?) {
        return (major, minor, patch, build)
    }

    public init() {
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let buildString = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"

        let versionArray = versionString.split(separator: ".")

        major = versionArray.count > 0 ? (Int(versionArray[0]) ?? 0) : 0
        minor = versionArray.count > 1 ? (Int(versionArray[1]) ?? 0) : 0
        patch = versionArray.count > 2 ? (Int(versionArray[2]) ?? 0) : 0

        build = Int(buildString) ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case major, minor, patch, build
        case description = "version"
    }
}
