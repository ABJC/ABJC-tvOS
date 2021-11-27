/*
 ABJC - tvOS
 Tab.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

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
