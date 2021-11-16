/*
 ABJC - tvOS
 Tabs.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

public extension PreferenceStore {
    enum Tabs: String, CaseIterable {
        case watchnow = "Watch Now"
        case movies = "Movies"
        case series = "TV Shows"
        case search = "Searchh"

        public var label: LocalizedStringKey {
            .init(rawValue)
        }

        public var description: LocalizedStringKey {
            .init("")
        }

        public static var `default`: Set<Tabs> {
            Set([Tabs.movies, Tabs.series, Tabs.search])
        }
    }
}

public extension Set where Element == PreferenceStore.Tabs {
    mutating func enable(_ tab: Element) {
        insert(tab)
    }

    mutating func disable(_ tab: Element) {
        remove(tab)
    }

    mutating func toggle(_ tab: Element) {
        if isEnabled(tab) {
            disable(tab)
        } else {
            enable(tab)
        }
    }

    mutating func set(_ tab: Element, to state: Bool) {
        if state != isEnabled(tab) {
            toggle(tab)
        }
    }

    func isEnabled(_ tab: Element) -> Bool {
        contains(tab)
    }
}
