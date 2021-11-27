/*
 ABJC - tvOS
 AnalyticsEvents.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import ABJCAnalytics
import AnyCodable
import Foundation
import JellyfinAPI
import TVVLCKit

enum AnalyticsEvents: AnalyticsEvent {
    case installed
    case updated

    case networkError(ErrorResponse)
    case unknownError(Error)
    case appError(AppError)
    case playbackError(VLCMediaPlayer)

    case preferences(PreferenceStore)

    var name: String {
        switch self {
            case .installed: return "installed"
            case .updated: return "updated"
            case .networkError: return "network-error"
            case .unknownError: return "unknown-error"
            case .appError: return "app-error"
            case .playbackError: return "playback-error"
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
                    "localizedDescription": error.localizedDescription
                ]
            case let .appError(error): return .init(error)
            case let .playbackError(player): return .init(player.analyticsData)
            case let .preferences(store): return .init(store.analyticsData)
        }
    }
}
