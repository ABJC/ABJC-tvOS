//
//  YearGroupingView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

extension LibraryView.GroupingViewContainer {
    struct YearGroupingView: GroupingView {
        internal let items: [String: APIModels.MediaItem]
        internal let categories: [String]
        internal let itemMap: [String: [String]]
        
        init(_ items: [APIModels.MediaItem]) {
            var itemMap: [String: [String]] = [:]
            
            for item in items {
                let category = item.year != nil ? "\(item.year!)" : "#"
                if itemMap.keys.contains(category) {
                    itemMap[category]!.append(item.id)
                } else {
                    itemMap[category] = [item.id]
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
            ForEach(categories, id:\.self) { category in
                LibraryView.MediaRowView(
                    String(category),
                    itemMap[category]!.compactMap({ items[$0] })
                )
                Divider()
            }
        }
    }
}

