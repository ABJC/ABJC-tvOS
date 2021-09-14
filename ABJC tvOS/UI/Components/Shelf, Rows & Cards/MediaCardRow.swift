//
//  MediaCardRow.swift
//  MediaCardRow
//
//  Created by Noah Kamara on 10.09.21.
//

import JellyfinAPI
import SwiftUI

struct MediaCardRow: View {
    @ObservedObject
    var store: MediaViewDelegate

    /// Label
    public let label: LocalizedStringKey

    /// Items
    public let items: [BaseItemDto]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.title3)
                .padding(.horizontal, store.edgeInsets.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 48) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: DetailView(item: item), label: {
                            MediaCard(store: store, item: item)
                        })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(height: store.rowHeight)
                .padding(store.edgeInsets)
            }.edgesIgnoringSafeArea(.horizontal)
        }.edgesIgnoringSafeArea(.horizontal)
    }
}

struct MediaCardRow_Previews: PreviewProvider {
    static var previews: some View {
        MediaCardRow(store: .init(), label: "label", items: [])
    }
}
