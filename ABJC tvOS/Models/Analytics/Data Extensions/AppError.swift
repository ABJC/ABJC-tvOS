//
//  AppError.swift
//  AppError
//
//  Created by Noah Kamara on 17.09.21.
//

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
