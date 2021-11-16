/*
 ABJC - tvOS
 DeviceInfo.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

public enum DeviceInfo {
    /// Operating System Name
    static var osName: String {
        UIDevice.current.systemName
    }

    /// Operating System Version
    static var osVersion: String {
        UIDevice.current.systemVersion
    }

    /// Device Model
    static var modelName: String {
        #if os(tvOS)
            print(UIDevice.current.systemVersion)
        #endif
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        /// Map Identifier to Model name
        func mapToModel(_ identifier: String) -> String {
            switch identifier {
                case "AppleTV5,3": return "Apple TV HD"
                case "AppleTV6,2": return "Apple TV 4K"
                case "AppleTV11,1": return "Apple TV 4K 2nd Gen"
                case "i386",
                     "x86_64": return "Simulator \(mapToModel(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
            }
        }

        return mapToModel(identifier)
    }
}
