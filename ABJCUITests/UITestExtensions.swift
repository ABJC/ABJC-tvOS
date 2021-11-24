/*
 ABJC - tvOS
 UITestExtensions.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import XCTest

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        typeText(deleteString)
        typeText(text)
    }
    //    func findAndPressButton(_ element: XCUIElement, _ button: XCUIRemote.Button) {
    //        let continueBtnHasFocus = expectation(for: .init(format: "exists == true"), evaluatedWith: element) {
    //            if element.buttons.firstMatch.hasFocus {
    //                XCUIRemote.shared.press(.select)
    //                return true
    //            } else {
    //                XCUIRemote.shared.press(button)
    //                return false
    //            }
    //        }
    //        wait(for: [continueBtnHasFocus], timeout: 10.0)
    //    }
}
