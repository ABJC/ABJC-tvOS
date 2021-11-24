/*
 ABJC - tvOS
 DirectPlayProfile.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

extension DirectPlayProfile {
    init(
        container: [PlayConstants.Container],
        audioCodec: [PlayConstants.AudioCodec],
        videoCodec: [PlayConstants.VideoCodec],
        type: DlnaProfileType
    ) {
        self.init(
            container: container.map(\.rawValue).joined(separator: ","),
            audioCodec: audioCodec.map(\.rawValue).joined(separator: ","),
            videoCodec: videoCodec.map(\.rawValue).joined(separator: ","),
            type: type
        )
    }

    static func detect(device: Device = .current) -> DirectPlayProfile {
        if device.isMinimumCpuModel(.a12) {
            return .init(
                container: [.mov, .mp4, .mkv, .webm],
                audioCodec: [.aac, .mp3, .wav, .ac3, .eac3, .flac, .truehd, .dts, .dca, .opus],
                videoCodec: [.h264, .hevc, .dvhe, .dvh1, .h264, .hevc, .hev1, .mpeg4, .vp9],
                type: .video
            )
        } else if device.isMinimumCpuModel(.a10X) {
            return .init(
                container: [.mov, .mp4, .mkv, .webm],
                audioCodec: [.aac, .mp3, .wav, .ac3, .eac3, .flac, .opus],
                videoCodec: [.dvhe, .dvh1, .h264, .hevc, .hev1, .mpeg4, .vp9],
                type: .video
            )
        } else {
            return .init(
                container: [.mov, .mp4, .mkv, .webm],
                audioCodec: [.aac, .mp3, .wav],
                videoCodec: [.h264, .mpeg4, .vp9],
                type: .video
            )
        }
    }
}
