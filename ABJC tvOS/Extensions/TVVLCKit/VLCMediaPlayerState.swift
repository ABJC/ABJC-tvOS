/*
 ABJC - tvOS
 VLCMediaPlayerState.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 20.09.21
 */

import Foundation
import TVVLCKit

extension VLCMediaPlayerState {
    var debugDescription: String {
        switch self {
            case .playing: return "playing"
            case .paused: return "paused"
            case .stopped: return "stopped"
            case .ended: return "ended"
            case .opening: return "opening"
            case .buffering: return "buffering"
            case .esAdded: return "esAdded"
            case .error: return "error"
            default: return "default \(rawValue)"
        }
    }
}

extension VLCMediaState {
    var debugDescription: String {
        switch self {
            case .playing: return "playing"
            case .error: return "error"
            case .buffering: return "buffering"
            case .nothingSpecial: return "nothingSpecial"
            @unknown default: return "@unknown \(rawValue)"
        }
    }
}
