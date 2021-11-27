/*
 ABJC - tvOS
 PlayConstants.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

class PlayConstants {
    enum Container: String {
        case ts
        case mov
        case mp4
        case mkv
        case webm
    }

    enum AudioCodec: String {
        case aac
        case mp3
        case wav
        case ac3
        case eac3
        case flac
        case truehd
        case dts
        case dca
        case opus
    }

    enum VideoCodec: String {
        case h264
        case mpeg4
        case vp9
        case dvhe
        case dvh1
        case hevc
        case hev1
    }
}
