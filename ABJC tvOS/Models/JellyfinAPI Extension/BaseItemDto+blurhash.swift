//
//  BaseItemDto+blurhash.swift
//  BaseItemDto+blurhash
//
//  Created by Noah Kamara on 10.09.21.
//

import Foundation
import JellyfinAPI

extension BaseItemDto {
    /// Retrieve the first available blurhash for the image types
    /// - Parameter imageType: Image type
    /// - Returns: BlurHash if available
    func blurhash(for imageType: ImageType) -> String? {
        guard let hashes = imageBlurHashes else { return nil }
        
        switch imageType {
            case .primary: return hashes.primary?.compactMap { $0.value }.first
            case .art: return hashes.art?.compactMap { $0.value }.first
            case .backdrop: return hashes.backdrop?.compactMap { $0.value }.first
            case .banner: return hashes.banner?.compactMap { $0.value }.first
            case .logo: return hashes.logo?.compactMap { $0.value }.first
            case .thumb: return hashes.thumb?.compactMap { $0.value }.first
            case .disc: return hashes.disc?.compactMap { $0.value }.first
            case .box: return hashes.box?.compactMap { $0.value }.first
            case .screenshot: return hashes.screenshot?.compactMap { $0.value }.first
            case .menu: return hashes.menu?.compactMap { $0.value }.first
            case .chapter: return hashes.chapter?.compactMap { $0.value }.first
            case .boxRear: return hashes.boxRear?.compactMap { $0.value }.first
            case .profile: return hashes.profile?.compactMap { $0.value }.first
        }
    }
}
