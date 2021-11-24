/*
 ABJC - tvOS
 BetaFlag.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

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
            .init("betaflags." + rawValue + ".label")
        }

        public var description: LocalizedStringKey {
            .init("betaflags." + rawValue + ".descr")
        }

        public static func availableFlags() -> [BetaFlag] {
            let config = Self.configuration()
            return Self.allCases.filter { config[$0] ?? false }
        }

        public static func configuration() -> [BetaFlag: Bool] {
            [
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
        contains(flag)
    }
}
