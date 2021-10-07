/*
 ABJC - tvOS
 MediaCardRow.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

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
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct MediaCardRow_Previews: PreviewProvider {
    static var previews: some View {
        MediaCardRow(store: .init(), label: "label", items: [])
    }
}
