/*
 ABJC - tvOS
 Blurhash.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import SwiftUI

struct Blurhash: View {
    @Environment(\.colorScheme) var colorScheme

    private let blurhash: String?
    private var shouldOverlay: Bool = false

    init(_ blurhash: String?) {
        self.blurhash = blurhash

        if let blurhash = blurhash {
            shouldOverlay = UIImage(blurHash: blurhash, size: .init(width: 5, height: 5))?.brightness ?? 0 > 150
        }
    }

    var body: some View {
        if let blurhash = blurhash {
            ZStack {
                Image(blurhash, size: .init(width: 16, height: 16), punch: 1)?
                    .resizable()
                    .overlay(colorOverlay)
            }
        } else {
            Blur()
        }
    }

    var colorOverlay: some View {
        Rectangle()
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .opacity(shouldOverlay ? 0.5 : 0)
    }
}

struct Blurhash_Previews: PreviewProvider {
    static var previews: some View {
        Blurhash("")
    }
}
