//
//  Grouping.swift
//  ABJC
//
//  Created by Noah Kamara on 14.07.21.
//

import SwiftUI

public enum Grouping: String, CaseIterable {
    static let `default`: Self = .genre
    
    case title = "title"
    case genre = "genre"
    case releaseYear = "releaseyear"
    case releaseDecade = "releasedecade"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey("collectionGrouping."+rawValue) }
}
