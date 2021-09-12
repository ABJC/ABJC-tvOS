//
//  PeopleCard.swift
//  PeopleCard
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI
import JellyfinAPI

struct PeopleCard: View {
    /// Person Item
    var person: BaseItemPerson
    
    private var size: CGSize = .init(width: 300, height: 400)
    
    @State var imageUrl: URL? = nil
    
    func loadImageUrl() {
        guard let name = person.name else {
            return
        }
        
        ImageAPI.getPersonImage(name: name, imageType: .primary) { result in
            switch result {
                case .success(let url): self.imageUrl = url
                case .failure(let error): print(error)
            }
        }
    }
    
    /// Initializer
    /// - Parameter person: Person Item
    public init(_ person: BaseItemPerson) {
        self.person = person
    }
    
    var body: some View {
        VStack {
            AsyncImg(url: imageUrl) { image in
                image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(alignment: .top)
            } placeholder: {
                Blur()
            }
            .clipShape(Circle())
            .clipped()
            .padding([.horizontal, .top], 15)
            .frame(width: size.width, height: size.width)
            
            VStack {
                Text(person.name ?? "No Name")
                Text(person.role ?? " ")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding([.horizontal, .bottom], 10)
        }.frame(width: size.width, height: size.height)
    }
}

//struct PeopleCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleCard(.preview)
//    }
//}
