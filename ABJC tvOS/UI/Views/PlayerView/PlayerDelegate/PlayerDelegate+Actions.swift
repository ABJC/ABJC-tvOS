/*
 ABJC - tvOS
 PlayerDelegate+Actions.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import Foundation
import SwiftUI

extension PlayerDelegate {
    /// Handle "play-pause" Command
    func playPauseAction() {
        logger.log.info("Command: PlayPause", tag: "PLAYER")
        if player.isPlaying {
            isShowingInterface = true
            player.pause()
        } else {
            player.play()
        }
    }

    /// Handle "move" Command
    func moveCommandAction(_ direction: MoveCommandDirection) {
        logger.log.info("Command: Move \(String(describing: direction))", tag: "PLAYER")
        switch direction {
            case .up:
                isShowingInterface = true
            case .down:
                isShowingInterface = true
            case .left:
                quickSeekBackward()
            case .right:
                quickSeekForward()

                #warning("Unknown Default not Handled")
            @unknown default:
                break
        }
    }
}
