/*
 ABJC - tvOS
 DetailView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

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
