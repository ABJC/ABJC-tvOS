//
//  MediaType.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation


extension APIModels {
    public enum MediaType: String, Codable, CaseIterable {
        case movie = "Movie"
        case series = "Series"
        case episode = "Episode"
    }
}
