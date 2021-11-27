/*
 ABJC - tvOS
 CustomButton.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct CustomButton<Content: View>: View {
    @Environment(\.isFocused) var isFocused

    private let action: () -> Void
    private let content: (Bool, Bool) -> Content
    @State var isPressed: Bool = false
    @FocusState var hasFocus: Bool

    init(_ action: @escaping () -> Void, _ content: @escaping (Bool, Bool) -> Content) {
        self.action = action
        self.content = content
    }

    var body: some View {
        content(hasFocus, isPressed)
            .focusable(true)
            .focused($hasFocus)
            .onLongPressGesture(minimumDuration: 0.01, pressing: pressing, perform: action)
    }

    func pressing(_ isPressed: Bool) {
        DispatchQueue.main.async {
            self.isPressed = isPressed
        }
    }
}

// struct CustomButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomButton()
//    }
// }
