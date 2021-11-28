/*
 ABJC - tvOS
 PreferenceStore.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import Combine
import SwiftUI

public class PreferenceStore: ObservableObject {
    static var shared: PreferenceStore = .init()

    internal enum Keys {
        static let firstBoot = "analytics.firstboot"
        static let lastVersion = "analytics.lastversion"
        static let analyticsConsent = "analytics.consent"
        
        static let shouldFetchCoverArt = "coverArt"
        static let grouping = "ui.configuration.collectiongrouping"

        static let posterType = "design.postertype"
        static let showsTitles = "design.showstitles"
        static let debugMode = "debugmode"
        static let betaflags = "betaflags"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    public let objectWillChange = PassthroughSubject<Void, Never>()

    static var defaultValues: [String: Any] = [
        Keys.lastVersion: Version().description,
        Keys.firstBoot: true,
        Keys.analyticsConsent: false,
        Keys.debugMode: false,
        Keys.shouldFetchCoverArt: false,
        Keys.grouping: CollectionGrouping.default.rawValue,
        Keys.posterType: PosterType.default.rawValue,
        Keys.showsTitles: false,
        Keys.betaflags: [],
    ]

    public func reset() {
        for pair in PreferenceStore.defaultValues {
            defaults.removeObject(forKey: pair.key)
        }

        for pair in PreferenceStore.defaultValues {
            defaults.set(pair.value, forKey: pair.key)
        }

        objectWillChange.send()
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: Self.defaultValues)

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    /// Current client version
    public let version = Version()

    /// Defines whether this is the first boot of the app
    public var isFirstBoot: Bool {
        get { defaults.bool(forKey: Keys.firstBoot) }
        set { defaults.set(newValue, forKey: Keys.firstBoot) }
    }

    /// Whether the user has consented to analytics
    public var hasAnalyticsConsent: Bool {
        get { defaults.bool(forKey: Keys.analyticsConsent) }
        set { defaults.set(newValue, forKey: Keys.analyticsConsent) }
    }

    // Defines whether the app was updated (first boot new version)
    public var wasUpdated: Bool {
        let value = defaults.string(forKey: Keys.lastVersion) ?? version.description
        defaults.set(version.description, forKey: Keys.lastVersion)
        return value != version.description
    }

    public var shouldFetchCoverArt: Bool {
        get { defaults.bool(forKey: Keys.shouldFetchCoverArt) }
        set { defaults.set(newValue, forKey: Keys.shouldFetchCoverArt) }
    }
    
    public var hasShownUpdateNotice: Bool = false

    public var updateNotice: UpdateNotices? {
        if !wasUpdated {
            return nil
        }

        switch version.tuple {
            // 1.0.0 Build 30
            case (1, 0, 0, 30):
                return .newCoverArt
            default:
                return nil
        }
    }

    /// Format of the poster shown for media titles
    public var posterType: PosterType {
        get { PosterType(rawValue: defaults.string(forKey: Keys.posterType) ?? "") ?? .default }
        set { defaults.setValue(newValue.rawValue, forKey: Keys.posterType) }
    }

    /// Wether to always show titles for media items
    public var showsTitles: Bool {
        get { defaults.bool(forKey: Keys.showsTitles) }
        set { defaults.setValue(newValue, forKey: Keys.showsTitles) }
    }

    /// Which grouping to use in Collection Views
    public var collectionGrouping: CollectionGrouping {
        get { CollectionGrouping(rawValue: defaults.string(forKey: Keys.grouping) ?? "genre") ?? .genre }
        set {
            defaults.setValue(newValue.rawValue, forKey: Keys.grouping)
            objectWillChange.send()
        }
    }

    /// Wether debug mode is enabled
    public var isDebugEnabled: Bool {
        get { defaults.bool(forKey: Keys.debugMode) }
        set {
            defaults.setValue(newValue, forKey: Keys.debugMode)
            objectWillChange.send()
        }
    }

    /// Beta Feature Flags
    public var betaflags: Set<BetaFlag> {
        get {
            let data = defaults.object(forKey: Keys.betaflags) as? [String] ?? [String]()
            let flags = data.filter { BetaFlag(rawValue: $0) != nil }.map { BetaFlag(rawValue: $0)! }
            return Set(flags)
        }
        set {
            defaults.set(newValue.map(\.rawValue), forKey: Keys.betaflags)
            objectWillChange.send()
        }
    }

    /// Indicates wether single page mode is active
    public var betaShowWatchNowTab: Bool {
        get {
            betaflags.isEnabled(.watchnowtab)
        }
        set {
            betaflags.set(.watchnowtab, to: newValue)
        }
    }

    /// Indicates wether uglymode is active
    public var betaUglymode: Bool {
        get {
            betaflags.isEnabled(.uglymode)
        }
        set {
            betaflags.set(.uglymode, to: newValue)
        }
    }
}
