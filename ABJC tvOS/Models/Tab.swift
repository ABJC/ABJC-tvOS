//
//  Tab.swift
//  Tab
//
//  Created by Noah Kamara on 10.09.21.
//

import Foundation
import SwiftUI

enum Tab: Int {
    case watchnow = 0
    case movies = 1
    case shows = 2
    case search = 3
    case preferences = 4

    var title: LocalizedStringKey {
        switch self {
        case .watchnow: return .init("Watch Now")
        case .movies: return .init("Movies")
        case .shows: return .init("TV Shows")
        case .search: return .init("Search")
        case .preferences: return .init("Preferences")
        }
    }
}
