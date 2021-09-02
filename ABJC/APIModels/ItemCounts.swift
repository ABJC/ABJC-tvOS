//
//  ItemCounts.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension APIModels {
    struct ItemCounts: Codable {
        var movies: Int
        var series: Int
        var episodes: Int
        var artists: Int
        var programs: Int
        var trailers: Int
        var songs: Int
        var albums: Int
        var musicvideos: Int
        var boxsets: Int
        var books: Int
        var items: Int
        
        enum CodingKeys: String, CodingKey {
            case movies = "MovieCount"
            case series = "SeriesCount"
            case episodes = "EpisodeCount"
            case artists = "ArtistCount"
            case programs = "ProgramCount"
            case trailers = "TrailerCount"
            case songs = "SongCount"
            case albums = "AlbumCount"
            case musicvideos = "MusicVideoCount"
            case boxsets = "BoxSetCount"
            case books = "BookCount"
            case items = "ItemCount"
        }
    }
}
