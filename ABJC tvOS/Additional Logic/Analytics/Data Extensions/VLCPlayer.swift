/*
 ABJC - tvOS
 VLCPlayer.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 19.09.21
 */

import AnyCodable
import Foundation
import TVVLCKit

extension VLCMediaPlayer {
    var analyticsData: [String: AnyEncodable] {
        [
            "state": .init(state),
            "position": .init(position),
            "bitrates": [
                "demux": media.demuxBitrate,
                "input": media.inputBitrate,
                "output": media.streamOutputBitrate
            ],
            "tracks": [
                "video": numberOfVideoTracks,
                "audio": numberOfAudioTracks,
                "subtitles": numberOfSubtitlesTracks
            ],
            "video": [
                "size": videoSize,
                "output": hasVideoOut,
                "tracks": numberOfVideoTracks
            ],
            "media": [
                "state": media.state,
                "is_suitable": media.isMediaSizeSuitableForDevice
            ]
        ]
    }
}
