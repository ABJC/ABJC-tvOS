/*
 ABJC - tvOS
 DeviceProfile.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

extension DeviceProfile {
    static func detect(device: Device = .current) -> DeviceProfile {
        let bitrate = 40_000_000
        let maxStreamingBitrate = bitrate
        let maxStaticBitrate = bitrate

        let directPlayProfile: DirectPlayProfile = .detect(device: device)
        let transcodingProfile: TranscodingProfile = .detect(device: device)
        let codecProfiles: [CodecProfile] = .detect(device: device)
        let responseProfiles: [ResponseProfile] = [ResponseProfile(container: "m4v", type: .video, mimeType: "video/mp4")]

        return .init(
            maxStreamingBitrate: maxStreamingBitrate,
            maxStaticBitrate: maxStaticBitrate,
            directPlayProfiles: [directPlayProfile],
            transcodingProfiles: [transcodingProfile],
            codecProfiles: codecProfiles,
            responseProfiles: responseProfiles
        )
    }
}
