//
//  AnalyticsTests.swift
//  AnalyticsTests
//
//  Created by Noah Kamara on 03.09.21.
//

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
