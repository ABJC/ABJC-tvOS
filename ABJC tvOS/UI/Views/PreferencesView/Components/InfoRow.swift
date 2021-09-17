//
//  InfoRow.swift
//  InfoRow
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

extension PreferencesView {
    struct InfoRow: View {
        private let label: LocalizedStringKey
        private let data: Any
        
        private var value: String {
            switch data {
                case let v as String: return v
                case let v as Int: return "\(v)"
                default: return "\(type(of: data))"
            }
        }
        
        init(_ label: LocalizedStringKey, _ data: Any) {
            self.label = label
            self.data = data
        }
        
        var body: some View {
            Button(action: {}) {
                HStack {
                    Text(label)
                    Spacer()
                    Text(value)
                }
            }.accessibilityIdentifier("inforow-" + label.stringKey)
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
