//
//  PlayButton.swift
//  PlayButton
//
//  Created by Noah Kamara on 15.09.21.
//

import SwiftUI

struct PlayButton: View {
    @Environment(\.isFocused)
    var isFocused
    private let label: LocalizedStringKey
    private let action: () -> Void

    init(_ label: LocalizedStringKey, _ action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Group {
            if isFocused {
                Text(label)
                    .bold()
                    .textCase(.uppercase)
                    .colorInvert()
            } else {
                Text(label)
                    .bold()
                    .textCase(.uppercase)
            }
        }
        .frame(width: 300)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(isFocused ? .thickMaterial : .thinMaterial)
        )

        .scaleEffect(isFocused ? 1.2 : 1)
        .animation(.easeInOut, value: isFocused)
        .frame(width: 200, height: 80)
        .onLongPressGesture(minimumDuration: 0.01, pressing: { _ in }) {
            action()
        }
        .focusable(true)
    }
}

// struct PlayButton_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayButton("IS Focus", {})
//    }
// }
