//
//  CollectionGrouping.swift
//  CollectionGrouping
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

public enum CollectionGrouping: String, CaseIterable {
    static let `default`: Self = .genre

    case title = "By Title"
    case genre = "By Genre"
    case releaseYear = "By Year"
    case releaseDecade = "By Decade"

    var localizedName: LocalizedStringKey { .init(rawValue) }
}
