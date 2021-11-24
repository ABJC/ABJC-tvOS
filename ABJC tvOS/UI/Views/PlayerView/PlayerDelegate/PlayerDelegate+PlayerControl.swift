/*
 ABJC - tvOS
 PlayerDelegate+PlayerControl.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

extension PlayerDelegate {
    func quickSeekBackward() {
        let seekBackwardSeconds: Int32 = 15
        logger.log.info("Seek: backward \(seekBackwardSeconds)s", tag: "PLAYER")
        player.jumpBackward(seekBackwardSeconds)
        objectWillChange.send()
    }

    func quickSeekForward() {
        let seekForwardSeconds: Int32 = 15
        logger.log.info("Seek: forward \(seekForwardSeconds)s", tag: "PLAYER")
        player.jumpForward(seekForwardSeconds)
        objectWillChange.send()
    }
}
