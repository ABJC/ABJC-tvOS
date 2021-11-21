/*
 ABJC - tvOS
 PreferenceStore+summary.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import AnyCodable
import Foundation

extension PreferenceStore {
    var analyticsData: [String: AnyEncodable] {
        [
            Keys.betaflags: .init(betaflags),
            Keys.grouping: .init(collectionGrouping),
            Keys.debugMode: .init(isDebugEnabled),
            Keys.posterType: .init(posterType),
            Keys.showsTitles: .init(showsTitles)
        ]
    }
}
