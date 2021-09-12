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
                default: return "\(type(of: self.data))"
            }
        }
        init(_ label: LocalizedStringKey, _ data: Any) {
            self.label = label
            self.data = data
        }
        
        var body: some View {
            Button(action: {})  {
                HStack {
                    Text(label)
                    Spacer()
                    Text(value)
                }
            }
        }
    }

    struct InfoRow_Previews: PreviewProvider {
        static var previews: some View {
            InfoRow(.init(""), "")
        }
    }
}
