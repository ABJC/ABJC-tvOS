/*
 ABJC - tvOS
 ButtonArea.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct ButtonArea<Content: View>: View {
    private let content: (Bool) -> Content
    private let action: () -> Void

    init(
        _ action: @escaping () -> Void,
        @ViewBuilder content: @escaping (Bool) -> Content
    ) {
        self.action = action
        self.content = content
    }

    @Environment(\.isFocused) var isFocused
    @State var isPressed: Bool = false

    var body: some View {
        content(isFocused)
            .focusable(true)
            .onLongPressGesture(minimumDuration: 0.01, pressing: pressing, perform: action)
    }

    func pressing(_ isPressed: Bool) {
        DispatchQueue.main.async {
            self.isPressed = isPressed
        }
    }
}

struct ButtonArea_Previews: PreviewProvider {
    static var previews: some View {
        ButtonArea({
            print("PRESSED")
        }, content: { isPressed in
            Text("isPressed \(isPressed.description)")
        })
    }
}
