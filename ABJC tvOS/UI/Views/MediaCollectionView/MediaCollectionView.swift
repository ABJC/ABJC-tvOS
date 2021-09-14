//
//  MediaCollectionView.swift
//  MediaCollectionView
//
//  Created by Noah Kamara on 09.09.21.
//

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
