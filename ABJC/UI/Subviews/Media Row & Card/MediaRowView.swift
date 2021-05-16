//
//  MediaRowView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

extension LibraryView
{
    struct MediaRowView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Edge Insets
        private var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
        
        /// Label
        private let label: LocalizedStringKey
        
        private var height: CGFloat {
            var _height = session.preferences.backdropTitleImages ? 300 : 340
            
            if session.preferences.showsTitles
            {
                _height += 100
            }
            return CGFloat(_height)
        }
        
        /// Items
        private let items: [APIModels.MediaItem]
        
        /// Initializer
        /// - Parameters:
        ///   - label: Row Label
        ///   - items: Row Items
        public init(_ label: String, _ items: [APIModels.MediaItem]) {
            self.label = LocalizedStringKey(label)
            self.items = items
        }
        
        /// Initializer
        /// - Parameters:
        ///   - label: Localized Row Label
        ///   - items: Row Items
        public init(_ label: LocalizedStringKey, _ items: [APIModels.MediaItem]) {
            self.label = label
            self.items = items
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.title3)
                    .padding(.horizontal, edgeInsets.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 48) {
                        ForEach(items, id:\.id) { item in
                            Button(action: {
                                session.setFocus(item)
                            }) {
                                MediaCardView(item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: height)
                    .padding(edgeInsets)
                }.edgesIgnoringSafeArea(.horizontal)
            }.edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    //struct MediaRowView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MediaRowView()
    //    }
    //}
}
