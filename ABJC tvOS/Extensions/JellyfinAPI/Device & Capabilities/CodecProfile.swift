/*
 ABJC - tvOS
 CodecProfile.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 20.11.21
 */

import Foundation
import JellyfinAPI

extension Array where Element == CodecProfile {
    static func detect(device: Device = .current) -> [CodecProfile] {
        // Codec Profile Conditions
        var codecProfiles: [CodecProfile] = [
            .init(
                type: .video,
                applyConditions: [
                    .init(condition: .notEquals, property: .isAnamorphic, value: "true", isRequired: false),
                    .init(
                        condition: .equalsAny,
                        property: .videoProfile,
                        value: "high|main|baseline|constrained baseline",
                        isRequired: false
                    ),
                    .init(condition: .lessThanEqual, property: .videoLevel, value: "80", isRequired: false),
                    .init(condition: .notEquals, property: .isInterlaced, value: "true", isRequired: false)
                ],
                codec: PlayConstants.VideoCodec.h264.rawValue
            )
        ]

        if device.isMinimumCpuModel(.a10X) {
            codecProfiles.append(
                .init(
                    type: .video,
                    applyConditions: [
                        .init(condition: .notEquals, property: .isAnamorphic, value: "true", isRequired: false),
                        .init(condition: .equalsAny, property: .videoProfile, value: "high|main|main 10", isRequired: false),
                        .init(condition: .lessThanEqual, property: .videoLevel, value: "175", isRequired: false),
                        .init(condition: .notEquals, property: .isInterlaced, value: "true", isRequired: false)
                    ],
                    codec: PlayConstants.VideoCodec.hevc.rawValue
                )
            )
        }

        return codecProfiles
    }
}
