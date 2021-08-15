//
//  MediaCardView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI
import URLImage

extension LibraryView
{
    struct MediaCardView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Size
        private var size: CGSize {
            return session.preferences.posterType == .poster ? CGSize(width: 225, height: 337.5) : CGSize(width: 548, height: 308.25)
        }
        
        /// Title image  aspect ratio
        private var ratio: CGFloat {
            return session.preferences.posterType == .poster ? 2/3 : 16/9
        }
        
        /// Media Item
        private var item: APIModels.MediaItem
        
        private var url: URL? {
            guard let jellyfin = session.jellyfin else {
                DispatchQueue.main.async {
                    session.itemPlaying = nil
                    session.itemFocus = nil
                }
                session.logout()
                return nil
            }
            let type : APIModels.ImageType = session.preferences.posterType == .poster ? .primary : .backdrop
            return API.imageURL(jellyfin, item.id, type)
        }
        /// Initializer
        /// - Parameter item: Item
        public init(_ item: APIModels.MediaItem) {
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
                .aspectRatio(ratio, contentMode: .fill)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width: size.width, height: size.height)
                .overlay(overlay, alignment: .bottom)
                if session.preferences.showsTitles {
                    HStack(alignment: .top) {
                        Text(item.name)
                            .bold()
                    }.frame(width: size.width, height: 90)
                }
            }
        }
        
        //    /// Placeholder for loading URLImage
        //    private var placeholder: some View {
        //        Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 8, height: 8)) ?? UIImage())
        //            .renderingMode(.original)
        //            .resizable()
        //    }
        
        
        private var uglymode: some View
        {
            Blur()
                .overlay(
                    VStack {
                        Text(item.name)
                            .font(.headline)
                        Text(item.year != nil ? "(" + String(item.year!) + ")" : "")
                    }.padding()
                )
        }
        /// Placeholder for missing URLImage
        private var blur: some View {
            Blur()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    VStack {
                        Text(item.name)
                            .font(.headline)
                        Text(item.year != nil ? "(" + String(item.year!) + ")" : "")
                    }.padding()
                )
        }
        
        /// URLImage
        private var image: some View {
            AsyncImg(url: url) { image in
                image
                    .renderingMode(.original)
                    .resizable()
            } placeholder: {
                Blur()
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
    
    //struct MediaCardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MediaCardView()
    //    }
    //}
}
