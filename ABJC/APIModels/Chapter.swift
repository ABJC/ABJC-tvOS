//
//  Chapter.swift
//  ABJC
//
//  Created by Noah Kamara on 10.08.21.
//

import Foundation


extension APIModels {
    struct Chapter: Codable {
        public let name: String
        public let positionTicks: Int
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case positionTicks = "StartPositionTicks"
        }
    }
}
