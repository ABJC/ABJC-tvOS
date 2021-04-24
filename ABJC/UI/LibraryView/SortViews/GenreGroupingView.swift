//
//  GenreView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

extension LibraryView.GroupingViewContainer {
    struct GenreGroupingView: GroupingView {
        internal let items: [String: APIModels.MediaItem]
        internal let categories: [APIModels.Genre]
        internal let itemMap: [APIModels.Genre: [String]]
        
        init(_ items: [APIModels.MediaItem]) {
            var itemMap: [APIModels.Genre: [String]] = [:]
            var genres = Set<APIModels.Genre>()
            
            for item in items {
                for genre in item.genres {
                    if itemMap.keys.contains(genre) {
                        itemMap[genre]!.append(item.id)
                    } else {
                        itemMap[genre] = [item.id]
                    }
                    
                    genres.insert(genre)
                }
            }
            
            let items = items.reduce(into: [String: APIModels.MediaItem]()) {
                $0[$1.id] = $1
            }
            self.items = items
            self.categories = Array(itemMap.keys).sorted(by: { $0.name < $1.name})
            self.itemMap = itemMap
        }
        
        var body: some View {
            ForEach(categories, id:\.id) { category in
                LibraryView.MediaRowView(
                    category.name,
                    itemMap[category]!.compactMap({ items[$0] })
                )
                Divider()
            }
        }
    }
}
