//
//  Extensions.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

public extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(where: {$0.hashValue == elem.hashValue}) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
