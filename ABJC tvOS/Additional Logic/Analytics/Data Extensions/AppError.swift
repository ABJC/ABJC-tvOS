/*
 ABJC - tvOS
 AppError.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import AnyCodable
import Foundation

class AppError: Encodable {
    let location: SourceCodeAttachement
    let data: [String: AnyEncodable]

    init(at location: SourceCodeAttachement, with data: [String: AnyEncodable]) {
        self.location = location
        self.data = data
    }

    static func with(_ data: [String: AnyEncodable], file: String = #file, function: String = #function, line: UInt = #line) -> AppError {
        AppError(at: .init(file: file, line: line, function: function), with: data)
    }
}
