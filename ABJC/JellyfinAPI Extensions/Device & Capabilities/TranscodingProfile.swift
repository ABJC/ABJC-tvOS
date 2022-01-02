/*
 ABJC - tvOS
 TranscodingProfile.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

extension TranscodingProfile {
    init(
        container: [PlayConstants.Container],
        audioCodec: [PlayConstants.AudioCodec],
        videoCodec: [PlayConstants.VideoCodec],
        type: DlnaProfileType,
        _protocol: String? = nil,
        context _: EncodingContext? = nil,
        maxAudioChannels: Int? = nil,
        minSegments: Int? = nil,
        breakOnNonKeyFrames: Bool? = nil
    ) {
        self.init(
            container: container.map(\.rawValue).joined(separator: ","),
            type: type,
            videoCodec: videoCodec.map(\.rawValue).joined(separator: ","),
            audioCodec: audioCodec.map(\.rawValue).joined(separator: ","),
            _protocol: _protocol,
            context: .streaming,
            maxAudioChannels: maxAudioChannels?.formatted(),
            minSegments: minSegments,
            breakOnNonKeyFrames: breakOnNonKeyFrames
        )
    }

    static func detect(device: Device = .current) -> TranscodingProfile {
        if device.isMinimumCpuModel(.a10X) {
            return .init(
                container: [.ts],
                audioCodec: [.aac, .mp3, .wav, .eac3, .ac3, .flac, .opus],
                videoCodec: [.h264, .mpeg4, .hevc],
                type: .video,
                _protocol: "hls",
                context: .streaming,
                maxAudioChannels: 6,
                minSegments: 2,
                breakOnNonKeyFrames: true
            )
        } else {
            return .init(
                container: [.ts],
                audioCodec: [.aac, .mp3, .wav],
                videoCodec: [.h264, .mpeg4],
                type: .video
            )
        }
    }
}
