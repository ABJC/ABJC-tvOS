//
//  CoverCardView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import SwiftUI
import URLImage

extension LibraryView
{
    struct CoverCardView: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var isFocus: Bool = false
        
        /// Item
        private let item: APIModels.MediaItem
        
        private var url: URL {
            return API.imageURL(session.jellyfin!, item.id, .backdrop, 1000)
        }
        
        /// Initializer
        /// - Parameter item: Item
        public init(_ item: APIModels.MediaItem) {
            self.item = item
        }
        
        var body: some View {
            GeometryReader() { geo in
                ZStack(alignment: .leading) {
//                    background
                    Blur()
                    HStack(alignment: .top) {
                        image
                            .aspectRatio(16/9, contentMode: .fit)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 23, style: .continuous))
                            .frame(height: 477)
                        info.padding()
                    }.padding(.horizontal, 40)
                }
                .clipped()
            }.frame(width: 1600, height: 500)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .focusable(true) { isFocus in
                self.isFocus = isFocus
            }
        }
        
        private var info: some View {
            VStack(alignment: .center) {
                Text(item.name)
                    .font(.title3)
                    .lineLimit(2)
                
                Text(item.type.rawValue + (item.year != nil ? " (\(String(item.year!)))" : ""))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                Text(item.overview ?? "")
                
                
                VStack {
                    Spacer()
                    Button(action: {
                        session.setFocus(item)
                    }) {
                        Text("More Info")
                    }
                    .frame(width: 300)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(.accentColor)
                    )
                    
                    Spacer()
                }
            }
        }
        /// URLImage
        private var image: some View {
            URLImage(
                url: url,
                empty: { placeholder },
                inProgress: { _ in placeholder },
                failure:  { _,_ in placeholder }
            ) { image in
                image
                    .renderingMode(.original)
                    .resizable()
            }
        }
        
        /// Placeholder for loading URLImage
        private var placeholder: some View {
            //        Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 8, height: 8)) ?? UIImage())
            //            .renderingMode(.original)
            //            .resizable()
            Blur()
        }
    }

//    struct CoverCardView_Previews: PreviewProvider {
//        static var previews: some View {
//            CoverCardView()
//        }
//    }
}
