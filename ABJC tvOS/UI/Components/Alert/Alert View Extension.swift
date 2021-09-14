//
//  Alert.swift
//  Alert
//
//  Created by Noah Kamara on 13.09.21.
//

import SwiftUI

extension View {
    func abjcAlert(_ binding: SwiftUI.Binding<AlertObject?>) -> some View {
        alert(item: binding) { alert in
            if !alert.hasTwoButtons {
                return Alert(title: alert.title,
                             message: alert.message,
                             dismissButton: alert.primaryBtn)
            } else {
                return Alert(title: alert.title,
                             message: alert.message,
                             primaryButton: alert.primaryBtn,
                             secondaryButton: alert.secondaryBtn)
            }
        }
    }
}
