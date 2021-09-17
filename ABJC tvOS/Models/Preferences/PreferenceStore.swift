//
//  Preferences.swift
//  Preferences
//
//  Created by Noah Kamara on 09.09.21.
//

import Combine
import SwiftUI

public class PreferenceStore: ObservableObject {
    static let shared: PreferenceStore = .init()

    private enum Keys {
        static let firstBoot = "analytics.firstboot"
        static let lastVersion = "analytics.lastversion"

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
        Keys.debugMode: false,
        Keys.grouping: CollectionGrouping.default.rawValue,
        Keys.posterType: PosterType.default.rawValue,
        Keys.showsTitles: false,
        Keys.betaflags: []
    ]

    public static func reset() {
        let defaults = UserDefaults.standard

        for pair in Self.defaultValues {
            defaults.removeObject(forKey: pair.key)
        }

        defaults.register(defaults: Self.defaultValues)
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: Self.defaultValues)

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)

        defer {
            defaults.set(false, forKey: Keys.firstBoot)
        }
    }

    /// Current client version
    public let version = Version()

    /// Defines whether this is the first boot of the app
    public var isFirstBoot: Bool {
        let value = defaults.bool(forKey: Keys.firstBoot)
        return value
    }

    // Defines whether the app was updated (first boot new version)
    public var wasUpdated: Bool {
        let value = defaults.string(forKey: Keys.lastVersion) ?? version.description
        defaults.set(version.description, forKey: Keys.lastVersion)
        return value != version.description
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
            defaults.set(newValue.map { $0.rawValue }, forKey: Keys.betaflags)
            objectWillChange.send()
        }
    }

    /// Indicates wether single page mode is active
    public var beta_showWatchNowTab: Bool {
        get {
            betaflags.isEnabled(.watchnowtab)
        }
        set {
            betaflags.set(.watchnowtab, to: newValue)
        }
    }

    /// Indicates wether uglymode is active
    public var beta_uglymode: Bool {
        get {
            betaflags.isEnabled(.uglymode)
        }
        set {
            betaflags.set(.uglymode, to: newValue)
        }
    }
}
