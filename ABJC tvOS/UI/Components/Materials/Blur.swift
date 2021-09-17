//
//  Blur.swift
//  Blur
//
//  Created by Noah Kamara on 10.09.21.
//

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
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
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
