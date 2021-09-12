//
//  ButtonArea.swift
//  ButtonArea
//
//  Created by Noah Kamara on 10.09.21.
//

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
