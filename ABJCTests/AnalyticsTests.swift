//
//  AnalyticsTests.swift
//  AnalyticsTests
//
//  Created by Noah Kamara on 03.09.21.
//

import XCTest
import AnalyticsClient
@testable import ABJC

class AnalyticsTests: XCTestCase {
    
    private var manager: AnalyticsManager!
    
    override func setUpWithError() throws {
        let constants = Constants.load
        self.manager = .testflight(url: constants.analytics_url,
                                   version: "NONE")
    }
    
    func testSendReport() throws {
        self.manager.log(.detailedReport([:]), in: .none, with: [:])
    }
}
