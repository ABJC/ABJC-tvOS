//
//  PosterType.swift
//  PosterType
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

public extension PreferenceStore {
    enum PosterType: String, CaseIterable {
        static let `default`: Self = .poster
        
        case poster = "Poster"
        case wide = "Wide"
        
        var localizedName: LocalizedStringKey { .init(rawValue) }
        
        var systemImage: String {
            switch self {
                case .poster: return "rectangle.portrait.fill"
                case .wide: return "rectangle.fill"
            }
        }
    }
}
