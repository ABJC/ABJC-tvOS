/*
 ABJC - tvOS
 SourceCodeAttachement.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

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
