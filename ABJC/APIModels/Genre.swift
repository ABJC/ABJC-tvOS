//
//  Genry.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    public struct Genre: Codable, Hashable {
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        public var id: String
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
        }
    }
}
