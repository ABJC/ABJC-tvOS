//
//  ViewIdentifier.swift
//  ViewIdentifier
//
//  Created by Noah Kamara on 14.09.21.
//

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
