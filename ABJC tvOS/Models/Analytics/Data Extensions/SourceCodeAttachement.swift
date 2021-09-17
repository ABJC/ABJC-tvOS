//
//  SourceCodeAttachement.swift
//  SourceCodeAttachement
//
//  Created by Noah Kamara on 17.09.21.
//

import Foundation

class SourceCodeAttachement: Encodable {
    let file: String
    let line: UInt
    let function: String

    internal init(file: String, line: UInt, function: String) {
        self.file = file
        self.line = line
        self.function = function
    }

    convenience init(file: String = #file, function: String = #function, line: UInt = #line) {
        self.init(file: file, line: line, function: function)
    }
}
