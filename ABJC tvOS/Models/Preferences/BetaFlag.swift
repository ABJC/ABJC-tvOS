//
//  BetaFlag.swift
//  BetaFlag
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

public extension PreferenceStore {
    /// BetaFlags
    enum BetaFlag: String, CaseIterable {
        /// Fast but ugly
        case uglymode

        /// Displays library as a single page
        case singlePageMode = "singlepagemode"

        /// Show "Watch Now" Tab
        case watchnowtab

        public var label: LocalizedStringKey {
            return .init("betaflags." + rawValue + ".label")
        }

        public var description: LocalizedStringKey {
            return .init("betaflags." + rawValue + ".descr")
        }

        public static func availableFlags() -> [BetaFlag] {
            let config = Self.configuration()
            return Self.allCases.filter { config[$0] ?? false }
        }

        public static func configuration() -> [BetaFlag: Bool] {
            return [
                .uglymode: true,
                .singlePageMode: false,
                .watchnowtab: false
            ]
        }
    }
}

public extension Set where Element == PreferenceStore.BetaFlag {
    mutating func enable(_ flag: Element) {
        insert(flag)
    }

    mutating func disable(_ flag: Element) {
        remove(flag)
    }

    mutating func toggle(_ flag: Element) {
        if isEnabled(flag) {
            disable(flag)
        } else {
            enable(flag)
        }
    }

    mutating func set(_ flag: Element, to state: Bool) {
        if state != isEnabled(flag) {
            toggle(flag)
        }
    }

    func isEnabled(_ flag: Element) -> Bool {
        return contains(flag)
    }
}
