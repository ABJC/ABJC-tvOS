/*
 ABJC - tvOS
 PeopleCardRow.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 07.10.21
 */

import JellyfinAPI
import SwiftUI

struct PeopleCardRow: View {
    /// Edge Insets
    private var edgeInsets = EdgeInsets(top: 30, leading: 80, bottom: 50, trailing: 80)

    /// Label
    private let label: LocalizedStringKey

    /// Items
    private let people: [BaseItemPerson]

    /// Initializer
    /// - Parameters:
    ///   - label: Localized Row Label
    ///   - people: Row People
    public init(_ label: LocalizedStringKey, _ people: [BaseItemPerson]) {
        self.label = label
        self.people = people
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title3)
                .padding(.horizontal, edgeInsets.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 48) {
                    ForEach(people, id: \.id) { person in
                        Button(action: {}) {
                            PeopleCard(person)
                        }
                    }
                }
                .frame(height: 450)
                .padding(edgeInsets)
            }
        }
    }
}

struct PeopleCardRow_Previews: PreviewProvider {
    static var previews: some View {
        PeopleCardRow("People Card Row", [])
    }
}
