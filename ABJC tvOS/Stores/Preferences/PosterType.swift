/*
 ABJC - tvOS
 PosterType.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

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
