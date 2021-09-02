//
//  ItemResponse.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    public struct ItemResponse<T: Decodable>: Decodable {
        let items: T
        
        enum CodingKeys: String, CodingKey {
            case items = "Items"
        }
    }
}
