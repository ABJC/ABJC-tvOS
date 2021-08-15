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
        
        private var size: CGSize = .init(width: 300, height: 400)
        
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
                    .padding([.horizontal, .top], 15)
                    .frame(width: size.width, height: size.width)
                
                VStack {
                    Text(person.name)
                    Text(person.role ?? " ")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }.padding([.horizontal, .bottom], 10)
            }.frame(width: size.width, height: size.height)
        }
        
        /// Image View
        var imageView: some View {
            AsyncImg(url: API.imageURL(session.jellyfin!, person.id, .primary)) { image in
                image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(alignment: .top)
            } placeholder: {
                blur
            }
        }
        
        /// Placeholder for missing URLImage
        private var blur: some View {
//            Blur().clipShape(Circle())
            Circle()
        }
    }
    
    //struct PersonCardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        PersonCardView(APIModels.Person.)
    //    }
    //}
}
