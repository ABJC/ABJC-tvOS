//
//  Authentication.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIErrors {
    enum Authentication: Error {
        case failedAuthentication
        case unknown
    }
}
