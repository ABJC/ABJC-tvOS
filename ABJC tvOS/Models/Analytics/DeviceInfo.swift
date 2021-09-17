//
//  DeviceInfo.swift
//  DeviceInfo
//
//  Created by Noah Kamara on 12.09.21.
//

import SwiftUI

public enum DeviceInfo {
    /// Operating System Name
    static var osName: String {
        return UIDevice.current.systemName
    }
    
    /// Operating System Version
    static var osVersion: String {
        return UIDevice.current.systemVersion
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
                case "i386", "x86_64": return "Simulator \(mapToModel(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
            }
        }
        
        return mapToModel(identifier)
    }
}
