//
//  AnalyticsEvents.swift
//  AnalyticsEvents
//
//  Created by Noah Kamara on 12.09.21.
//

import ABJCAnalytics
import AnyCodable
import Foundation
import JellyfinAPI

enum AnalyticsEvents: AnalyticsEvent {
    case installed
    case updated
    case networkError(ErrorResponse)
    case unknownError(Error)
    case preferences(PreferenceStore)
    case appError(AppError)

    var name: String {
        switch self {
        case .installed: return "installed"
        case .updated: return "updated"
        case .networkError: return "network-error"
        case .unknownError: return "unknown-error"
        case .appError: return "app-error"
        case .preferences: return "preferences"
        }
    }

    var data: AnalyticsData {
        switch self {
        case .installed: return nil
        case .updated: return nil
        case let .networkError(error): return .init(NetworkError(error))
        case let .unknownError(error): return [
                "type": String(describing: type(of: error)),
                "detail": String(describing: error),
                "localizedDescription": error.localizedDescription,
            ]
        case let .appError(error): return .init(error)
        case let .preferences(store): return .init(store.analyticsData)
        }
    }
}
