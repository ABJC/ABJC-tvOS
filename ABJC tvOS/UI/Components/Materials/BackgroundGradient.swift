/*
 ABJC - tvOS
 BackgroundGradient.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

extension View {
    func background() -> some View {
        background(BackgroundViews.gradient)
    }
}

enum BackgroundViews {
    static var gradient: some View {
        LinearGradient(
            colors: [Color(uiColor: .init(red: 0.003, green: 0.095, blue: 0.310, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }

    static var blur: some View {
        Blur()
            .edgesIgnoringSafeArea(.all)
    }
}

// struct BackgroundGradient_Previews: PreviewProvider {
//    static var previews: some View {
//        BackgroundGradient<LinearGradient>()
//    }
// }
