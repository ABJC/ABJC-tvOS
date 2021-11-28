/*
 ABJC - tvOS
 CoverArtMatcher.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import Foundation
import JellyfinAPI

struct CoverArtResponse: Codable {
    public let success: Bool
    public let item: ItemMatch?

    struct ItemMatch: Codable {
        public let score: Score
        public let title: String
        public let releaseYear: Int?
        public let coverArt: CoverArt
    }

    struct Score: Codable {
        public let score: Float
        public let type: Float
        public let title: Float
        public let wordScore: Float
        public let year: Float
        public let description: Float
    }

    struct CoverArt: Codable {
        public let coverArt: URL?
        public let logo: URL?
    }
}

enum CoverArtItemType: String {
    case movie
    case tvshow

    static func fromItemType(_ itemType: ItemType) -> CoverArtItemType? {
        switch itemType {
            case .movie:
                return .movie
            case .series:
                return .tvshow
            default:
                return nil
        }
    }
}

enum CoverArtMatcher {
    static func match(item: BaseItemDto) async -> CoverArtResponse? {
//        var urlComponents: URLComponents = .init(string: "http://localhost:8000/coverart/topmatch")!
//        urlComponents.queryItems = [
//            .init(name: "type", value: CoverArtItemType.fromItemType(ItemType(rawValue: item.type ?? "") ?? .movie)?.rawValue ?? ""),
//            .init(name: "title", value: item.name ?? ""),
//            .init(name: "year", value: item.productionYear != nil ? "\(item.productionYear ?? 0)" : "")
//        ]
//
//        guard let url = urlComponents.url else {
//            return nil
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let object = try JSONDecoder().decode(CoverArtResponse.self, from: data)
//            return object
//        } catch {
//            print(error)
//            return nil
//        }
        return nil
    }
}
