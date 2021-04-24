//
//  Tabs.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

extension PreferenceStore {
    public enum Tabs: String, CaseIterable {
        case watchnow = "watchnow"
        case movies = "movies"
        case series = "series"
        case search = "search"
        
        public var label: LocalizedStringKey {
            return LocalizedStringKey("library."+self.rawValue+".label")
        }
        
        public var description: LocalizedStringKey {
            return LocalizedStringKey("library."+self.rawValue+".descr")
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
