//
//  MediaCard.swift
//  MediaCard
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI
import JellyfinAPI

struct MediaCard: View {
    /// Media Item
    @ObservedObject var store: MediaViewDelegate
    
    /// Media Item
    public let item: BaseItemDto
        
    @State private var imageUrl: URL? = nil
    
    func loadImageUrl() {
        guard let itemId = item.id else {
            return
        }
        let imageType: ImageType = store.preferences.posterType == .poster ? .primary : .backdrop
        ImageAPI.getItemImage(itemId: itemId, imageType: imageType) { result in
            switch result {
                case .success(let url): self.imageUrl = url
                case .failure(let error): print(error)
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                blur
                if !store.preferences.beta_uglymode {
                    image
                }
            }
            .aspectRatio(store.imageAspectRatio, contentMode: .fill)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .frame(width: store.cardSize.width, height: store.cardSize.height)
            .overlay(overlay, alignment: .bottom)
            if store.preferences.showsTitles {
                HStack(alignment: .top) {
                    Text(item.name ?? "No Title")
                }
                .padding(8)
                .frame(width: store.cardSize.width, height: 90, alignment: .top)
            }
        }.onAppear(perform: loadImageUrl)
    }
    
    private var uglymode: some View
    {
        Blur()
            .overlay(
                VStack {
                    Text(item.name ?? "No Title")
                        .font(.headline)
                    Text(item.productionYear != nil ? "(" + String(item.productionYear!) + ")" : "")
                }.padding()
            )
    }
    
    /// Placeholder for missing URLImage
    private var blur: some View {
        Blur()
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                VStack {
                    Text(item.name ?? "No Name")
                        .font(.headline)
                    Text(item.productionYear != nil ? "(" + String(item.productionYear!) + ")" : "")
                }.padding()
            )
    }
    
    /// URLImage
    private var image: some View {
        AsyncImg(url: imageUrl) { image in
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
        }.frame(width: store.cardSize.width, height: store.cardSize.height)
    }
}

//struct MediaCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MediaCard(store: .init(), item: .preview)
//    }
//}
