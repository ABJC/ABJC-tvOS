//
//  PlaybuttonStyle.swift
//  ABJC
//
//  Created by Noah Kamara on 25.04.21.
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
            .onLongPressGesture(minimumDuration: 0.01, pressing: { _ in }) {
                print("PRESSED")
            }
    }
    
    func pressing(_ isPressed: Bool) {
        DispatchQueue.main.async {
            self.isPressed = isPressed
        }
    }
}
struct PlayButton: View {
    @Environment(\.isFocused) var isFocused
    private let label: LocalizedStringKey
    private let action: () -> Void
    
    init(_ label: LocalizedStringKey, _ action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Group() {
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
            Group() {
                if isFocused {
                    Blur(.extraLight)
                } else {
                    Blur(.light)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
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
struct PlaybuttonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    @Environment(\.colorScheme) var colorScheme    
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Group() {
            if isFocused {
                configuration.label
                    .colorInvert()
            } else {
                configuration.label
            }
        }
        .padding()
        .background(
            Group() {
                if isFocused {
                    Blur(.extraLight)
                } else {
                    Blur(.light)
                }
            }
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        )
        
        .scaleEffect(configuration.isPressed ? 0.95: 1)
        .scaleEffect(isFocused ? 1.2 : 1)
        .animation(.easeInOut, value: isFocused)
        .frame(width: 200, height: 80)
    }
}
