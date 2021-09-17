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
            switch ItemType(rawValue: item.type ?? "") ?? .episode {
            case .movie:
                MovieDetailView(store: .init(item)).accessibilityIdentifier("movieDetailView")
            case .series:
                SeriesDetailView(store: .init(item)).accessibilityIdentifier("seriesDetailView")
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
