/*
 ABJC - tvOS
 ViewModifiers.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

extension View {
    // Modifier allows the view to be hidden but still retains the frame within the layout
    @ViewBuilder
    func hidden(_ hide: Bool) -> some View {
        if hide { hidden() } else { self }
    }
}
