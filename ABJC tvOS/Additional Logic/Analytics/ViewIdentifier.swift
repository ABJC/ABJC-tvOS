/*
 ABJC - tvOS
 ViewIdentifier.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Foundation

enum ViewIdentifier: Encodable {
    case auth
    case library(ItemType)
    case detail(ItemType)

    var rawValue: String {
        switch self {
            case .auth: return "auth"
            case let .library(type): return "library-\(type)"
            case let .detail(type): return "detail-\(type)"
        }
    }
}
