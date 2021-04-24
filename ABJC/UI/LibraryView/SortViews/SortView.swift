//
//  SortView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

public enum Grouping: String, CaseIterable {
    case title = "title"
    case genre = "genre"
    case releaseYear = "releaseyear"
    case releaseDecade = "releasedecade"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey("collectionGrouping."+rawValue) }
}

protocol GroupingView: View {
    associatedtype Category: Hashable
    var items: [String: APIModels.MediaItem] { get }
    var categories: [Category] { get }
    var itemMap: [Category: [String]] { get }
}

extension LibraryView {
    struct GroupingViewContainer: View {
        @EnvironmentObject var session: SessionStore

        private let items: [APIModels.MediaItem]
        
        init(_ items: [APIModels.MediaItem]) {
            self.items = items
        }
        
        var body: some View {
            if session.preferences.collectionGrouping == .genre {
                GenreGroupingView(items)
            } else if session.preferences.collectionGrouping == .title {
                TitleGroupingView(items)
            } else if session.preferences.collectionGrouping == .releaseYear {
                YearGroupingView(items)
            } else if session.preferences.collectionGrouping == .releaseDecade {
                DecadeGroupingView(items)
            } else {
                Text("Grouping Error")
            }
        }
    }
}
