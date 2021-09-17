//
//  Analytics.swift
//  Analytics
//
//  Created by Noah Kamara on 05.09.21.
//

import Foundation
import AnalyticsClient

extension AnalyticsManager {
    public static func testflight(url: URL, version: String) -> AnalyticsManager {
        let app_info: [String: String] = [
            "version": version
        ]
        return .init(engine: TestflightAnalyticsEngine(url), app_info: app_info)
    }
}

class TestflightAnalyticsEngine: AnalyticsEngine {
    private let url: URL
    private let firestore: FirestoreClient = .init()
    
    init(_ analyticsURL: URL) {
        self.url = analyticsURL
    }
    
    private func sendReport(_ report: AnalyticsReport) {
        do {
            let data = try JSONEncoder().encode(report)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                print("ERROR")
                return
            }
            firestore.addDocument(json) { error in
                print(error)
            }
        } catch let error {
            print(error)
        }
    }
    
    
    public func sendAnalyticsEvent(_ report: AnalyticsReport) {
        sendReport(report)
    }
}
