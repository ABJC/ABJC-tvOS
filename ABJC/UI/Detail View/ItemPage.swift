//
//  ItemPage.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI

extension LibraryView
{
    struct ItemPage: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Media Item
        private let item: APIModels.MediaItem
        
        
        /// Initializer
        /// - Parameter item: Media Item
        public init(_ item: APIModels.MediaItem) {
            self.item = item
        }
        
        var body: some View {
            Group {
                switch item.type {
                    case .movie:  MoviePage(item)
                    case .series:  SeriesPage(item)
                    default:  EmptyView()
                }
            }
        }
    }

//    struct ItemPage_Previews: PreviewProvider {
//        static var previews: some View {
//            ItemPage()
//        }
//    }
}
