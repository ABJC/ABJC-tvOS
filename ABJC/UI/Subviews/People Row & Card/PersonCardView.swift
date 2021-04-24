//
//  PersonCardView.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI
import URLImage

extension PeopleRowView {
    struct PersonCardView: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Person Item
        var person: APIModels.Person
        
        private var size: CGFloat = 300
        
        /// Initializer
        /// - Parameter person: Person Item
        public init(_ person: APIModels.Person) {
            self.person = person
        }
        
        var body: some View {
            VStack {
                imageView
                    .clipShape(Circle())
                    .clipped()
                    .frame(width: size, height: size)
                    .padding([.horizontal, .top], 10)
                
                VStack {
                    Text(person.name)
                    Text(person.role ?? " ")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }.padding([.horizontal, .bottom], 10)
            }.frame(width: size)
        }
        
        /// Image View
        var imageView: some View {
            URLImage(
                url: API.imageURL(session.jellyfin!,
                                  person.id,
                                  .primary),
                empty: { blur },
                inProgress: { _ in blur },
                failure:  { _,_ in blur }
            ) { image in
                image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(alignment: .top)
            }
        }
        
        /// Placeholder for missing URLImage
        private var blur: some View {
            Blur().clipShape(Circle())
        }
    }
    
    //struct PersonCardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        PersonCardView(APIModels.Person.)
    //    }
    //}
}
