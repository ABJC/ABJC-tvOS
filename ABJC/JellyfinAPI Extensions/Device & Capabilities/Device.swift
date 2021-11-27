/*
 ABJC - tvOS
 Device.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

struct Device {
    let cpuModel: CPUModel

    func isMinimumCpuModel(_ model: CPUModel) -> Bool {
        model <= cpuModel
    }

    static let atv_HD: Device = .init(cpuModel: .a8)
    static let atv_4k: Device = .init(cpuModel: .a10X)
    static let atv_4k2g: Device = .init(cpuModel: .a12)
    static let none: Device = .init(cpuModel: .a99)

    static var current: Device {
        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
            case "AppleTV5,3": return .atv_HD
            case "AppleTV6,2": return .atv_4k
            case "AppleTV11,1": return .atv_4k2g
            default: return .none
        }
    }

    enum CPUModel: Int, Comparable {
        static func < (lhs: CPUModel, rhs: CPUModel) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        case a99 = -1
        case a8 = 1
        case a10X = 2
        case a12 = 3
    }
}
