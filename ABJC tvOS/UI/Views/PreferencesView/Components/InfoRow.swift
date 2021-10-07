/*
 ABJC - tvOS
 InfoRow.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

extension PreferencesView {
    struct InfoRow: View {
        private let label: LocalizedStringKey
        private let data: Any?
        private let focusable: Bool

        private var value: String {
            switch data {
                case nil: return "-"
                case let v as String: return v
                case let v as Int: return "\(v)"
                case let v as Int32: return "\(v)"
                case let v as Float: return "\(v)"
                case let v as Bool: return v ? "yes" : "no"
                default: return "\(type(of: data))"
            }
        }

        init(_ label: LocalizedStringKey, _ data: Any?, _ focusable: Bool = true) {
            self.label = label
            self.data = data
            self.focusable = focusable
        }

        var body: some View {
            Group {
                if focusable {
                    Button(action: {}) {
                        innerView
                    }
                } else {
                    innerView
                }
            }.accessibilityIdentifier("inforow-" + label.stringKey)
        }

        var innerView: some View {
            HStack {
                Text(label)
                Spacer()
                Text(value)
            }
        }
    }

    struct InfoRow_Previews: PreviewProvider {
        static var previews: some View {
            InfoRow(.init(""), "")
        }
    }
}

extension LocalizedStringKey {
    // imagine `self` is equal to LocalizedStringKey("KEY_HERE")

    var stringKey: String {
        let description = "\(self)"
        // in this example description will be `LocalizedStringKey(key: "KEY_HERE", hasFormatting: false, arguments: [])`
        // for more clarity, `let description = "\(self)"` will have no differences
        // compared to `let description = "\(LocalizedStringKey(key: "KEY_HERE", hasFormatting: false, arguments: []))"` in this example.

        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }
        // here we separate the string by its components.
        // in `LocalizedStringKey(key: "KEY_HERE", hasFormatting: false, arguments: [])`
        // our key lays between two strings which are `key: "` and `",`.
        // if we manage to get what is between `key: "` and `",`, that would be our Localization Key
        // which in this example is `KEY_HERE`

        return components[1][0]
        // by trial, we know that `components[1][0]` will always be our localization Key
        // which is `KEY_HERE` in this example.
    }
}
