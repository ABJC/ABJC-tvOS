//
//  EpisodeRowView.swift
//  ABJC
//
//  Created by Noah Kamara on 05.04.21.
//

import SwiftUI

extension LibraryView
{
    struct EpisodeRowView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Edge Insets
        private var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
        
        /// Label
        private let label: LocalizedStringKey
        
        /// Items
        private let items: [APIModels.Episode]
        
        @Binding var seasonId: Int?
        
        @Binding var selection: APIModels.Episode?
        
        /// Initializer
        /// - Parameters:
        ///   - label: Row Label
        ///   - items: Row Items
        public init(
            _ label: String,
            _ items: [APIModels.Episode],
            _ seasonId: Binding<Int?>,
            _ selection: Binding<APIModels.Episode?>
        ) {
            self.label = LocalizedStringKey(label)
            self.items = items
            self._seasonId = seasonId
            self._selection = selection
        }
        
        /// Initializer
        /// - Parameters:
        ///   - label: Localized Row Label
        ///   - items: Row Items
        public init(
            _ label: LocalizedStringKey,
            _ items: [APIModels.Episode],
            _ seasonId: Binding<Int?>,
            _ selection: Binding<APIModels.Episode?>
        ) {
            self.label = label
            self.items = items
            self._seasonId = seasonId
            self._selection = selection
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.title3)
                    .padding(.horizontal, edgeInsets.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 48) {
                        ForEach(items, id:\.id) { item in
                            Button(action: {
                                DispatchQueue.main.async {
                                    self.selection = item
                                }
                            }, label: {
                                EpisodeCardView(item)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: 500)
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

