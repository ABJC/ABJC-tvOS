/*
 ABJC - tvOS
 Blur.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct Blur: View {
    public var style: UIBlurEffect.Style = .regular

    var body: some View {
        LegacyBlur(style)
    }
}

struct Blur_Previews: PreviewProvider {
    static var previews: some View {
        Blur()
    }
}

public struct LegacyBlur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    public init(_ style: UIBlurEffect.Style = .regular) {
        self.style = style
    }

    public func makeUIView(context _: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct LegacyBlur_Previews: PreviewProvider {
    static var previews: some View {
        LegacyBlur()
            .previewDevice("Apple TV")
    }
}
