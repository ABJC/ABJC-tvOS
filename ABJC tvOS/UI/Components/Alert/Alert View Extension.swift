/*
 ABJC - tvOS
 Alert View Extension.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import SwiftUI

extension View {
    func abjcAlert(_ binding: SwiftUI.Binding<AlertObject?>) -> some View {
        alert(item: binding) { alert in
            if !alert.hasTwoButtons {
                return Alert(
                    title: alert.title,
                    message: alert.message,
                    dismissButton: alert.primaryBtn
                )
            } else {
                return Alert(
                    title: alert.title,
                    message: alert.message,
                    primaryButton: alert.primaryBtn,
                    secondaryButton: alert.secondaryBtn
                )
            }
        }
    }
}
