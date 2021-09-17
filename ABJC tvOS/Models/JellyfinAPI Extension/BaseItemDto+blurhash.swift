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
        case .primary: return hashes.primary?.compactMap(\.value).first
        case .art: return hashes.art?.compactMap(\.value).first
        case .backdrop: return hashes.backdrop?.compactMap(\.value).first
        case .banner: return hashes.banner?.compactMap(\.value).first
        case .logo: return hashes.logo?.compactMap(\.value).first
        case .thumb: return hashes.thumb?.compactMap(\.value).first
        case .disc: return hashes.disc?.compactMap(\.value).first
        case .box: return hashes.box?.compactMap(\.value).first
        case .screenshot: return hashes.screenshot?.compactMap(\.value).first
        case .menu: return hashes.menu?.compactMap(\.value).first
        case .chapter: return hashes.chapter?.compactMap(\.value).first
        case .boxRear: return hashes.boxRear?.compactMap(\.value).first
        case .profile: return hashes.profile?.compactMap(\.value).first
        }
    }
}
