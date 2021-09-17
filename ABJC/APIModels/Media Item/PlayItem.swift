//
//  PlayableMediaItem.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import Foundation

protocol Playable {
    var id: String { get }
    var name: String { get }
    var mediaSources: [APIModels.MediaSource] { get }
}

class PlayItem: Identifiable, Playable {
    let id: String
    let name: String
    let mediaSources: [APIModels.MediaSource]
    
    
    init<T: Playable>(_ playable: T) {
        self.id = playable.id
        self.name = playable.name
        self.mediaSources = playable.mediaSources
    }
}

//extension APIModels {
//    
//}

