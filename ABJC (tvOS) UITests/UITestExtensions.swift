//
//  UITestExtensions.swift
//  UITestExtensions
//
//  Created by Noah Kamara on 16.09.21.
//

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
