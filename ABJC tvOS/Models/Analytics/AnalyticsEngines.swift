//
//  CustomAnalyticsEngine.swift
//  CustomAnalyticsEngine
//
//  Created by Noah Kamara on 12.09.21.
//

import ABJCAnalytics
import Foundation

class MockAnalyticsEngine: AnalyticsEngine {
    func send(_ report: AnalyticsReport) {
        print("REPORT", report.eventName)
    }
}

class TestflightAnalyticsEngine: AnalyticsEngine {
    func send(_ report: AnalyticsReport) {
        guard let analytics = Constants.current?.analytics else {
            return
        }
        guard var urlComponents = URLComponents(string: analytics.uri) else {
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: analytics.key)]
        guard let url = urlComponents.url else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(report)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
            }

            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("RESULT", json ?? "")
            }
        }.resume()
    }
}
