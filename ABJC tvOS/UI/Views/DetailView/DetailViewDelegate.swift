//
//  ItemDetailViewDelegate.swift
//  ItemDetailViewDelegate
//
//  Created by Noah Kamara on 10.09.21.
//

import Foundation
import JellyfinAPI

class DetailViewDelegate: ViewDelegate {
    
    public let item: BaseItemDto
    @Published var imageUrl: URL? = nil
    @Published var itemSimilars: [BaseItemDto] = []
//    @Published var actors: [BaseItemPerson] = []
//    @Published var studio: String?
//    @Published var director: String?
//    @Published var itemPeople: [Person] = []
    
    
    // Loads imageUrl
    func loadImageUrl() {
        guard let itemId = item.id else {
            return
        }
        let imageType: ImageType = preferences.posterType == .poster ? .primary : .backdrop
        ImageAPI.getItemImage(itemId: itemId, imageType: imageType) { result in
            switch result {
                case .success(let url): self.imageUrl = url
                case .failure(let error): print(error)
            }
        }
    }
    
    
    func loadItemsSimilar() {
        
    }
    
    func onAppear() {
        loadImageUrl()
        
//        switch ItemType(rawValue: item.type ?? "") ?? .episode {
//            case .movie: loadMovie()
////            case .series: loadSeries()
//            default: print("NOT IMPLEMENTED")
//        }
    }
    
    func play() {
        
    }
    
    init(_ item: BaseItemDto) {
        self.item = item
    }
}
