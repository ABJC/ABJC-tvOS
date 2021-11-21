/*
 ABJC - tvOS
 AnalyticsEngines.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 20.11.21
 */

import ABJCAnalytics
import Foundation

class MockAnalyticsEngine: AnalyticsEngine {
    let logger: Logger = .shared

    func send(_ report: AnalyticsReport) {
        if let data = try? JSONEncoder().encode(report),
           let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            print("REPORT '\(report.eventName)'", json)
        } else {
            print("REPORT '\(report.eventName)'")
        }
    }
}

class TestflightAnalyticsEngine: AnalyticsEngine {
    let logger: Logger = .shared

    func send(_ report: AnalyticsReport) {
        logger.log.info("sending report for \(report.eventName)", tag: "Analytics")

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

        print(report)
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
