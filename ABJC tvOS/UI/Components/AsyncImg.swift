/*
 ABJC - tvOS
 AsyncImg.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 19.11.21
 */

import SwiftUI
import URLImage

struct AsyncImg<I: View, P: View>: View {
    let url: URL?
    let content: (Image) -> I
    let placeholder: () -> P

    init(url: URL?, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) {
        self.content = content
        self.placeholder = placeholder
        self.url = url
    }

    var body: some View {
        AsyncImage(url: url, content: content, placeholder: placeholder)
            .accessibilityIdentifier("async-img")
    }
}

// struct AsyncImg_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncImg()
//    }
// }
