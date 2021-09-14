//
//  Blurhash.swift
//  Blurhash
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

struct Blurhash: View {
    @Environment(\.colorScheme)
    var colorScheme

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
