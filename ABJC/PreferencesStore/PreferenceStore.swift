//
//  PreferenceStore.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

import Foundation
import Combine
import SwiftUI

public class PreferenceStore: ObservableObject {
    private enum Keys {
        static let watchnowtab = "tabviewconfiguration.watchnowtab"
        static let seriestab = "tabviewconfiguration.seriestab"
        static let moviestab = "tabviewconfiguration.moviestab"
        static let searchtab = "tabviewconfiguration.searchtab"
        static let tabs = "ui.configuration.tabs"
        static let grouping = "ui.configuration.collectiongrouping"
        
        static let posterType = "design.postertype"
        static let showsTitles = "design.showstitles"
        static let debugMode = "debugmode"
        static let betaflags = "betaflags"
    }
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(defaults: UserDefaults = .standard) {
        #if DEBUG
        if CommandLine.arguments.contains("-factoryUserDefaults") {
            let defaults = UserDefaults(suiteName: #file)!
            defaults.removePersistentDomain(forName: #file)
        }
        #endif
        
        self.defaults = defaults
        
        // Load Beta Flags
        let data = defaults.object(forKey: Keys.betaflags) as? [String] ?? [String]()
        let flags = Set(data.filter({ BetaFlag(rawValue: $0) != nil }).map({BetaFlag(rawValue: $0)!}))
        
        defaults.register(defaults: [
            Keys.tabs: Tabs.default.map({ $0.rawValue }),
            Keys.debugMode: false,
            Keys.grouping: Grouping.default.rawValue,
            Keys.posterType: PosterType.default.rawValue,
            Keys.showsTitles: flags.contains(.showsTitles),
            Keys.betaflags: []
        ])
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    
    /// Current client version
    public let version: Version = Version()
    
    
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
    
    /// Wether to show the "Watch Now" Tab
    public var showsWatchNowTab: Bool {
        get { tabs.isEnabled(.watchnow) }
        set { tabs.set(.watchnow, to: newValue) }
    }
    
    /// Wether to show the "Movies" Tab
    public var showsMoviesTab: Bool {
        get { tabs.isEnabled(.movies) }
        set { tabs.set(.movies, to: newValue) }
    }
    
    /// Wether to show the "TV Shows" Tab
    public var showsSeriesTab: Bool {
        get { tabs.isEnabled(.series) }
        set { tabs.set(.series, to: newValue) }
    }
    
    /// Wether to show the "Search" Tab
    public var showsSearchTab: Bool {
        get { tabs.isEnabled(.search) }
        set { tabs.set(.search, to: newValue) }
    }
    
    
    /// The Enabled Tabs
    public var tabs: Set<Tabs> {
        get {
            let data = defaults.object(forKey: Keys.tabs) as? [String] ?? [String]()
            let tabs = data.filter({ Tabs(rawValue: $0) != nil }).map({Tabs(rawValue: $0)!})
            return Set(tabs)
        }
        set {
            defaults.set(newValue.map({ $0.rawValue }), forKey: Keys.tabs)
            objectWillChange.send()
        }
    }
    
    /// Which grouping to use in Collection Views
    public var collectionGrouping: Grouping {
        get { Grouping(rawValue: defaults.string(forKey: Keys.grouping) ?? "genre") ?? .genre }
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
            self.objectWillChange.send()
        }
    }
    
    
    /// Beta Feature Flags
    public var betaflags: Set<BetaFlag> {
        get {
            let data = defaults.object(forKey: Keys.betaflags) as? [String] ?? [String]()
            let flags = data.filter({ BetaFlag(rawValue: $0) != nil }).map({BetaFlag(rawValue: $0)!})
            return Set(flags)
        }
        set {
            defaults.set(newValue.map({ $0.rawValue }), forKey: Keys.betaflags)
            objectWillChange.send()
        }
    }
    
    
    /// Indicates wether single page mode is active
    public var beta_singlePagemode: Bool {
        get {
            betaflags.isEnabled(.singlePageMode)
        }
        set {
            betaflags.set(.singlePageMode, to: newValue)
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
    
    /// Indicates wether cover rows are active
    public var beta_coverRows: Bool {
        get {
            betaflags.isEnabled(.coverRows)
        }
        set {
            betaflags.set(.coverRows, to: newValue)
        }
    }
    
    
    /// Indicates wether iTunesCoverFetch is active
    public var beta_fetchCoverArt: Bool {
        get {
            betaflags.isEnabled(.coverArt)
        }
        set {
            betaflags.set(.coverArt, to: newValue)
        }
    }
}


/// Representation of a Version
public struct Version {
    public var description: String {
        if isTestFlight {
            return "[BETA] \(major).\(minor).\(patch) (\(build!))"
        } else {
            return "\(major).\(minor).\(patch)"
        }
    }
    
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let build: Int?
    
    public var isTestFlight: Bool {
        return build != nil
    }
    
    public init() {
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
        let buildString = Bundle.main.infoDictionary!["CFBundleVersion"]! as! String
        
        self.major = Int(versionString.split(separator: ".")[0]) ?? 0
        self.minor = Int(versionString.split(separator: ".")[1]) ?? 0
        self.patch = Int(versionString.split(separator: ".")[2]) ?? 0
        
        self.build = Int(buildString) ?? 0
    }
}
