/*
 ABJC - tvOS
 AnalyticsTests.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

@testable import ABJC
import AnalyticsClient
import XCTest

class AnalyticsTests: XCTestCase {
    private var manager: AnalyticsManager!

    override func setUpWithError() throws {
        let constants = Constants.load
        manager = .testflight(
            url: constants.analytics_url,
            version: "NONE"
        )
    }

    func testSendReport() throws {
        manager.log(.detailedReport([:]), in: .none, with: [:])
    }
}
