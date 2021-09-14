//
//  ItemDetailView.swift
//  ItemDetailView
//
//  Created by Noah Kamara on 10.09.21.
//

import JellyfinAPI
import SwiftUI

struct DetailView: View {
    public let item: BaseItemDto

    var body: some View {
        Group {
            switch ItemType(rawValue: item.type ?? "") ?? .movie {
            case .movie:
                MovieDetailView(store: .init(item))
            case .series:
                Text("HELLO THERE")
            default:
                Text("No View for Type: \(item.type ?? "")")
            }
        }
    }
}

// struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(item: .preview)
//    }
// }
