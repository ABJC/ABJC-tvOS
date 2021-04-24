//
//  PeopleRow.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI

struct PeopleRowView: View {
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    /// Edge Insets
    private var edgeInsets = EdgeInsets(top: 30, leading: 85, bottom: 50, trailing: 0)
    
    /// Label
    private let label: LocalizedStringKey
    
    /// Items
    private let people: [APIModels.Person]
        
    /// Initializer
    /// - Parameters:
    ///   - label: Localized Row Label
    ///   - people: Row People
    public init(_ label: LocalizedStringKey, _ people: [APIModels.Person]) {
        self.label = label
        self.people = people
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title3)
                .padding(.horizontal, edgeInsets.leading)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 48) {
                    ForEach(people, id:\.id) { person in
                        Button(action: {}) {
                            PersonCardView(person)
                        }
                    }
                }
                .padding(edgeInsets)
            }
        }
    }
}

struct PeopleRowView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleRowView("People Row", [])
    }
}
