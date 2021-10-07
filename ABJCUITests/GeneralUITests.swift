/*
 ABJC - tvOS
 GeneralUITests.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import XCTest

class GeneralUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test Launch Performance
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testDetailItemFocus() {
        let app = XCUIApplication()
        app.launchArguments = ["authenticate", "user=user_hidden"]
        app.launch()
        XCUIRemote.shared.press(.select)
        XCUIRemote.shared.press(.select)
        XCUIRemote.shared.press(.down)
    }
}
