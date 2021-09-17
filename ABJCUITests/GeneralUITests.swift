//
//  ABJC__tvOS__UITestsLaunchTests.swift
//  ABJC (tvOS) UITests
//
//  Created by Noah Kamara on 13.09.21.
//

import XCTest

class GeneralUITests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

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
}
