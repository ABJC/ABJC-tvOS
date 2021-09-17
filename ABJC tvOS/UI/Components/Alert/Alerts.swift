//
//  Alerts.swift
//  Alerts
//
//  Created by Noah Kamara on 13.09.21.
//

import Foundation
import SwiftUI

enum Alerts: String {
    case authenticationFailed
    case cantConnectToHost
    case failedToLoadItems
    
    var title: LocalizedStringKey {
        switch self {
            case .authenticationFailed:
                return "Authentication failed"
            case .cantConnectToHost:
                return "Can't connect to Host"
            case .failedToLoadItems:
                return "Failed to load items"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .authenticationFailed:
                return "Have you entered your username and password correctly?"
            case .cantConnectToHost:
                return "Have you entered the server Address and Port correctly?"
            case .failedToLoadItems:
                return "If this issue persists, please file feedback at https://github.com/abjc/abjc-tvos"
        }
    }
    
    var primaryBtn: Alert.Button {
        switch self {
            default:
                return .cancel()
        }
    }
    
    var secondaryBtn: Alert.Button? {
        switch self {
            default:
                return nil
        }
    }
}
