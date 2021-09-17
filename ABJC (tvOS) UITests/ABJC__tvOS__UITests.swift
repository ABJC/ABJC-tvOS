//
//  ABJC__tvOS__UITests.swift
//  ABJC (tvOS) UITests
//
//  Created by Noah Kamara on 13.09.21.
//

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

class ABJC__tvOS__UITests: XCTestCase {
    /// Test Launch Performance
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
