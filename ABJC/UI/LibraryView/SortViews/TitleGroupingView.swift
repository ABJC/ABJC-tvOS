//
//  TitleGroupingView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

extension LibraryView.GroupingViewContainer {
    struct TitleGroupingView: GroupingView {
        internal let items: [String: APIModels.MediaItem]
        internal let categories: [Character]
        internal let itemMap: [Character: [String]]
        
        init(_ items: [APIModels.MediaItem]) {
            var itemMap: [Character: [String]] = [:]
            
            for item in items {
                let letter = item.name.first ?? "#"
                if itemMap.keys.contains(letter) {
                    itemMap[letter]!.append(item.id)
                } else {
                    itemMap[letter] = [item.id]
                }
            }
            
            let items = items.reduce(into: [String: APIModels.MediaItem]()) {
                $0[$1.id] = $1
            }
            self.items = items
            self.categories = Array(itemMap.keys).sorted(by: { $0 < $1})
            self.itemMap = itemMap
        }
        
        var body: some View {
            ForEach(categories) { letter in
                LibraryView.MediaRowView(
                    String(letter),
                    itemMap[letter]!.compactMap({ items[$0] })
                )
                Divider()
            }
        }
    }
}
