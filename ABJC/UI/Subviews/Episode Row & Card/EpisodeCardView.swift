//
//  EpisodeRowCard.swift
//  ABJC
//
//  Created by Noah Kamara on 05.04.21.
//

import SwiftUI
import URLImage

extension LibraryView
{
    struct EpisodeCardView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Size
        private var size: CGSize = CGSize(width: 548, height: 308.25 )
//        private var size: CGSize = CGSize(width: 640, height: 360 )
        
        /// Media Item
        private var item: APIModels.Episode
        
        private var url: URL {
            return API.imageURL(session.jellyfin!, item.id, .primary)
        }
        /// Initializer
        /// - Parameter item: Item
        public init(_ item: APIModels.Episode) {
            self.item = item
        }
        
        var body: some View {
            VStack {
                ZStack {
                    blur
                    if !session.preferences.beta_uglymode {
                        image
                    }
                }
                .aspectRatio(16/9, contentMode: .fill)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width: size.width, height: size.height)
                .overlay(overlay, alignment: .bottom)
                VStack {
                    Text("Episode \(item.index ?? 0)")
                    Text(item.name)
                        .font(.headline)
                }.foregroundColor(.primary)
                .padding()
                .frame(width: size.width, height: 120)
            }
        }
        
        //    /// Placeholder for loading URLImage
        //    private var placeholder: some View {
        //        Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 8, height: 8)) ?? UIImage())
        //            .renderingMode(.original)
        //            .resizable()
        //    }
        
        
        /// Placeholder for missing URLImage
        private var blur: some View {
            Blur()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    Text("\(item.index ?? 0)")
                        .font(.largeTitle)
                )
        }
        
        /// URLImage
        private var image: some View {
            URLImage(
                url,
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
        
        
        /// PlaybackPosition Overlay
        private var overlay: some View {
            VStack {
                Spacer()
                //                if(item.runTimeTicks != nil) && item.userData.playbackPosition != 0 {
                //                    ZStack(alignment: .leading) {
                //                        Blur()
                //                            .clipShape(Capsule())
                //                        Capsule()
                //                            .frame(width: (geo.size.width-40) * CGFloat(Double(item.userData.playbackPositionTicks) / Double(item.runTimeTicks!)))
                //                            .padding(1)
                //                    }.frame(height: 10).padding(20)
                //                }
            }.frame(width: size.width, height: size.height)
        }
    }
}
