/*
 ABJC - tvOS
 Array.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Foundation

extension Array {
    func get(_ index: Int) -> Element? {
        if index >= startIndex, index <= endIndex {
            return self[index]
        }

        return nil
    }
}
