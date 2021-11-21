/*
 ABJC - tvOS
 MoveCommandModifiers.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 19.11.21
 */

import SwiftUI

extension View {
    func onMove(_ directions: [MoveCommandDirection], _ action: @escaping (() -> Void) = {}) -> some View {
        onMoveCommand { direction in
            if directions.contains(direction) {
                action()
            }
        }
    }
}
