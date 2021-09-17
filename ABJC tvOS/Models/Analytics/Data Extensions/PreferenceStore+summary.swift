//
//  PreferenceStore+summary.swift
//  PreferenceStore+summary
//
//  Created by Noah Kamara on 14.09.21.
//

import AnyCodable
import Foundation

extension PreferenceStore {
    var analyticsData: [String: AnyEncodable] {
        return [
            Keys.betaflags: .init(betaflags),
            Keys.grouping: .init(collectionGrouping),
            Keys.debugMode: .init(isDebugEnabled),
            Keys.posterType: .init(posterType),
            Keys.showsTitles: .init(showsTitles)
        ]
    }
}
