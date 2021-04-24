//
//  PlayableMediaItem.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import Foundation

protocol PlayableMediaItem {
    var id: String { get }
    var name: String { get }
    var mediaSources: [APIModels.MediaSource] { get }
}

//extension APIModels {
//    
//}

