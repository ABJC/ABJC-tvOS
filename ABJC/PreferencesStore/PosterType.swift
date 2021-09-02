//
//  PosterType.swift
//  ABJC
//
//  Created by Noah Kamara on 18.05.21.
//

import SwiftUI

extension PreferenceStore {
    public enum PosterType: String, CaseIterable {
        static let `default`: Self = .poster
        
        case poster = "poster"
        case wide = "wide"
        
        var localizedName: LocalizedStringKey { LocalizedStringKey("postertype."+rawValue) }
    }
}
