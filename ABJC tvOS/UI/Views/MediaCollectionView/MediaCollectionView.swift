/*
 ABJC - tvOS
 MediaCollectionView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

struct MediaCollectionView: View {
    public let itemType: ItemType
    @StateObject
    var store: MediaCollectionViewDelegate = .init()

    var body: some View {
        Shelf(store.items, grouped: store.preferences.collectionGrouping)
            .id(store.preferences.collectionGrouping.rawValue + store.items.isEmpty.description)
            .onAppear {
                self.store.loadItems(for: [itemType])
            }
            .abjcAlert($store.alert)
    }
}

struct MediaCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCollectionView(itemType: .movie)
    }
}
