//
//  PosterType.swift
//  PosterType
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

extension PreferenceStore {
    public enum PosterType: String, CaseIterable {
        static let `default`: Self = .poster
        
        case poster = "Poster"
        case wide = "Wide"
        
        var localizedName: LocalizedStringKey { .init(rawValue) }
    }
}
