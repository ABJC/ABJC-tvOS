/*
 ABJC - tvOS
 AsyncImg.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import SwiftUI
import URLImage

struct AsyncImg<I: View, P: View>: View {
    let url: URL?
    let content: (Image) -> I
    let placeholder: () -> P

    init(url: URL?, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let url = url {
                // If compiling for iOS 15, use first party AsyncImage instead of URLImage package
                if #available(tvOS 15.0, *) {
                    #warning("Replace palceholder with AsyncImage for iOS 15")
                    AsyncImage(url: url, content: content, placeholder: placeholder)
                } else {
                    URLImage(
                        url,
                        identifier: url.absoluteString,
                        empty: placeholder,
                        inProgress: { _ in placeholder() },
                        failure: { _, _ in placeholder() },
                        content: content
                    )
                }
            } else {
                placeholder()
            }
        }.accessibilityIdentifier("async-img")
    }
}

// struct AsyncImg_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncImg()
//    }
// }
