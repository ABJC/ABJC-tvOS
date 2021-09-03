//
//  AnalyticsTests.swift
//  AnalyticsTests
//
//  Created by Noah Kamara on 03.09.21.
//

import XCTest
import AnalyticsClient

class AnalyticsTests: XCTestCase {
    
    private var manager: AnalyticsManager!
    
    override func setUpWithError() throws {
//        self.manager = .testflight(url: Constants.analytics_url)
    }
    
    func testSendReport() throws {
        self.manager.log(.detailedReport([:]), in: .none, with: [:])
    }
}
