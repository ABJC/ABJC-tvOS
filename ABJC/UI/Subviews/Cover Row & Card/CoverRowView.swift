//
//  CoverRowView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI

extension LibraryView
{
    struct CoverRowView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Edge Insets
        private let edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
        
        /// Row Label
        private var label: LocalizedStringKey? = nil
        
        /// Row Items
        private var items: [APIModels.MediaItem]
        
        /// Initializer
        /// - Parameters:
        ///   - label: Localized Row Label
        ///   - items: Row Items
        public init(_ label: LocalizedStringKey?, _ items: [APIModels.MediaItem]) {
            self.label = label
            self.items = items
        }
        
        /// Initializer
        /// - Parameters:
        ///   - label: Localized Row Label
        ///   - items: Row Items
        public init(_ items: [APIModels.MediaItem]) {
            self.label = nil
            self.items = items
        }
        
        /// ViewBuilder body
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 48) {
                        ForEach(items, id:\.id) { item in
                            CoverCardView(item)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: 500)
                    .padding(edgeInsets)
                }
                .edgesIgnoringSafeArea(.horizontal)
            }
            .edgesIgnoringSafeArea(.horizontal)
        }
    }

//    struct CoverRowView_Previews: PreviewProvider {
//        static var previews: some View {
//            CoverRowView()
//        }
//    }
}
