/*
 ABJC - tvOS
 ToggleRow.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 20.11.21
 */

import SwiftUI

extension PreferencesView {
    struct ToggleRow: View {
        private let title: LocalizedStringKey
        private let subtitle: LocalizedStringKey?
        @Binding var value: Bool

        init(_ title: LocalizedStringKey, _ subtitle: LocalizedStringKey?, _ value: Binding<Bool>) {
            self.title = title
            self.subtitle = subtitle
            _value = value
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
                .accessibilityIdentifier("togglerow-" + title.stringKey)
        }
    }

    struct ToggleRow_Previews: PreviewProvider {
        static var previews: some View {
            ToggleRow(.init("High Ground"), .init("Cannot be countered\nAll attacking creatures get amputated"), .constant(true))
        }
    }
}
