/*
 ABJC - tvOS
 AppEnvironment.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

enum AppEnvironment {
    case debug
    case appstore
    case testflight

    static var current: AppEnvironment {
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            print("Couldn't Fetch AppStoreReceiptURL")
            return .debug
        }

        switch path {
            case let path where path.contains("CoreSimulator"):
                return .debug
            case let path where path.contains("sandboxReceipt"):
                return .testflight
            default:
                return .appstore
        }
    }
}
