//
//  PeopleCardRow.swift
//  PeopleCardRow
//
//  Created by Noah Kamara on 10.09.21.
//

import JellyfinAPI
import SwiftUI

struct PeopleCardRow: View {
    /// Edge Insets
    private var edgeInsets = EdgeInsets(top: 30, leading: 85, bottom: 50, trailing: 0)

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
