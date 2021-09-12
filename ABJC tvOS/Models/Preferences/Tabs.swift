//
//  Tabs.swift
//  Tabs
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI

extension PreferenceStore {
    public enum Tabs: String, CaseIterable {
        case watchnow = "Watch Now"
        case movies = "Movies"
        case series = "TV Shows"
        case search = "Searchh"
        
        public var label: LocalizedStringKey {
            return .init(rawValue)
        }
        
        public var description: LocalizedStringKey {
            return .init("")
        }
        
        public static var `default`: Set<Tabs> {
            return Set([Tabs.movies, Tabs.series, Tabs.search])
        }
    }
}

public extension Set where Element == PreferenceStore.Tabs {
    mutating func enable(_ tab: Element) {
        self.insert(tab)
    }
    
    mutating func disable(_ tab: Element) {
        self.remove(tab)
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
        return self.contains(tab)
    }
}
