/*
 ABJC - tvOS
 VLCMediaPlayer+Tracks.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import Foundation
import TVVLCKit

class Track: Identifiable, Equatable, Comparable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }

    static func < (lhs: Track, rhs: Track) -> Bool {
        lhs.index < rhs.index
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }

    internal init(index: Int32, name: String) {
        self.index = index
        self.name = name
    }

    var id: Int32 { index }
    var index: Int32
    var name: String
}

extension VLCMediaPlayer {
    func setVideoTrack(_ track: Track) {
        currentVideoTrackIndex = track.index
    }

    func setAudioTrack(_ track: Track) {
        currentAudioTrackIndex = track.index
    }

    var currentVideoTrack: Track? {
        videoTracks.first { track in
            track.index == currentVideoTrackIndex
        }
    }

    var currentAudioTrack: Track? {
        audioTracks.first { track in
            track.index == currentAudioTrackIndex
        }
    }

    var videoTracks: [Track] {
        videoTrackNames.indices.compactMap { idx in
            guard let index = videoTrackIndexes[idx] as? Int32,
                  let name = videoTrackNames[idx] as? String else {
                return nil
            }
            return Track(index: index, name: name)
        }
    }

    var audioTracks: [Track] {
        audioTrackNames.indices.compactMap { idx in
            guard let index = audioTrackIndexes[idx] as? Int32,
                  let name = audioTrackNames[idx] as? String else {
                return nil
            }
            return Track(index: index, name: name)
        }
    }
}
