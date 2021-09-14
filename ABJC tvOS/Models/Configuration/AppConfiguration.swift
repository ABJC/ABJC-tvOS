//
//  AppConfiguration.swift
//  AppConfiguration
//
//  Created by Noah Kamara on 11.09.21.
//

import ABJCAnalytics
import AnyCodable
import SwiftUI

class AppConfiguration {
    static var current: AppConfiguration { .init(environment: .current) }

    static var debug: AppConfiguration { .init(environment: .debug) }
    static var testflight: AppConfiguration { .init(environment: .testflight) }
    static var appstore: AppConfiguration { .init(environment: .appstore) }

    init(environment: AppEnvironment) {
        self.environment = environment

        let version = Version()
        let appInfo: [String: AnyEncodable] = [
            "version": [
                "version": version.description,
                "major": version.major,
                "minor": version.minor,
                "patch": version.patch,
                "build": version.build ?? 0
            ],
            "os": [
                "name": DeviceInfo.osName,
                "version": DeviceInfo.osVersion
            ],
            "device": .init(DeviceInfo.modelName)
        ]

        let engine: AnalyticsEngine = environment == .debug ? DebugAnalyticsEngine() : ProductionAnalyticsEngine()
        analytics = .init(engine: engine, appInfo: appInfo)
    }

    /// App Run Environment
    var environment: AppEnvironment

    var analytics: AnalyticsManager<AnalyticsEvents>

    var logLevel: String {
        switch environment {
        case .debug: return "DEBUG"
        case .appstore: return "WARNING"
        case .testflight: return "INFO"
        }
    }
}

private struct AppConfigurationKey: EnvironmentKey {
    static let defaultValue: AppConfiguration = .current
}

extension EnvironmentValues {
    var appConfiguration: AppConfiguration {
        get { self[AppConfigurationKey.self] }
        set { self[AppConfigurationKey.self] = newValue }
    }
}
