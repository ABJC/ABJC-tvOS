//
//  PreferencesView+Subviews.swift
//  ABJC
//
//  Created by Noah Kamara on 23.04.21.
//

import SwiftUI

extension PreferencesView{
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
    
    
    struct InfoToggle: View {
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
}
