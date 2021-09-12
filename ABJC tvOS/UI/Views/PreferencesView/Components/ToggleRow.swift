//
//  ToggleRow.swift
//  ToggleRow
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

extension PreferencesView {
    struct ToggleRow: View {
        private let title: LocalizedStringKey
        private let subtitle: LocalizedStringKey?
        @Binding var value: Bool
        
        init(_ title: LocalizedStringKey, _ subtitle: LocalizedStringKey?, _ value: Binding<Bool>) {
            self.title = title
            self.subtitle = subtitle
            self._value = value
        }
        
        var body: some View {
            Toggle(isOn: $value, label: {
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                    Text(subtitle ?? "")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            })
        }
    }
    
    struct ToggleRow_Previews: PreviewProvider {
        static var previews: some View {
            ToggleRow(.init("High Ground"), .init("Cannot be countered\nAll attacking creatures get amputated"), .constant(true))
        }
    }
}
