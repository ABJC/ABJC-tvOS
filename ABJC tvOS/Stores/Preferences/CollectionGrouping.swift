/*
 ABJC - tvOS
 CollectionGrouping.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import SwiftUI

public enum CollectionGrouping: String, CaseIterable {
    static let `default`: Self = .genre

    case title = "By Title"
    case genre = "By Genre"
    case releaseYear = "By Year"
    case releaseDecade = "By Decade"

    var localizedName: LocalizedStringKey { .init(rawValue) }
}
