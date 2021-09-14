//
//  AnalyticsEvents.swift
//  AnalyticsEvents
//
//  Created by Noah Kamara on 12.09.21.
//

import ABJCAnalytics
import Foundation
import JellyfinAPI

enum AnalyticsEvents: AnalyticsEvent {
    case installed
    case updated
    case networkError(ErrorResponse)

    var name: String {
        switch self {
        case .installed: return "installed"
        case .updated: return "updated"
        case .networkError: return "network-error"
        }
    }

    var data: AnalyticsData {
        switch self {
        case .installed: return nil
        case .updated: return nil
        case let .networkError(error): return .init(NetworkError(error))
        }
    }
}
