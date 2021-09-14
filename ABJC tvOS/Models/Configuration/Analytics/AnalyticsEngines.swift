//
//  CustomAnalyticsEngine.swift
//  CustomAnalyticsEngine
//
//  Created by Noah Kamara on 12.09.21.
//

import ABJCAnalytics
import Foundation

class DebugAnalyticsEngine: AnalyticsEngine {
    func send(_ report: AnalyticsReport) {
//        do {
//            try report.log()
//        } catch {
//            print("ERROR", error)
//        }
        print("AnalyticsReport: \(report.eventName)")
    }
}

class ProductionAnalyticsEngine: AnalyticsEngine {
    func send(_ report: AnalyticsReport) {
        print("REPORT", report.description)
    }
}
