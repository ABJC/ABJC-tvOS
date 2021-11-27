/*
 ABJC - tvOS
 BaseItemDto.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation
import JellyfinAPI

extension BaseItemDto: Identifiable {
    /// Indicates whether the item can be continued
    var isContinue: Bool { userData?.playbackPositionTicks != 0 }

    /// Retrieve the first available blurhash for the image types
    /// - Parameter imageType: Image type
    /// - Returns: BlurHash if available
    func blurhash(for imageType: ImageType) -> String? {
        guard let hashes = imageBlurHashes else { return nil }

        switch imageType {
            case .primary: return hashes.primary?.values.first
            case .art: return hashes.art?.values.first
            case .backdrop: return hashes.backdrop?.values.first
            case .banner: return hashes.banner?.values.first
            case .logo: return hashes.logo?.values.first
            case .thumb: return hashes.thumb?.values.first
            case .disc: return hashes.disc?.values.first
            case .box: return hashes.box?.values.first
            case .screenshot: return hashes.screenshot?.values.first
            case .menu: return hashes.menu?.values.first
            case .chapter: return hashes.chapter?.values.first
            case .boxRear: return hashes.boxRear?.values.first
            case .profile: return hashes.profile?.values.first
        }
    }
}
