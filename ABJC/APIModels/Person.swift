//
//  Person.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import Foundation

extension APIModels {
    public struct Person: Codable {
        public var id: String
        public var name: String
        public var role: String?
        public var type: String
        public var image: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case role = "Role"
            case type = "Type"
            case image = "PrimaryImageTag"
        }
    }
}
