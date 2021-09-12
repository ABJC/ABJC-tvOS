//
//  AppEnvironment.swift
//  AppEnvironment
//
//  Created by Noah Kamara on 11.09.21.
//

import Foundation

enum AppEnvironment {
    case debug
    case appstore
    case testflight
    
    
    static var current: AppEnvironment {
#if DEBUG
        return .debug
#endif
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            print("Couldn't Fetch AppStoreReceiptURL")
            return .debug
        }
        
        print("PATH", path)
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
