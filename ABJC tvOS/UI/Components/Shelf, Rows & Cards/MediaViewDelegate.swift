/*
 ABJC - tvOS
 MediaViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import JellyfinAPI
import SwiftUI

class MediaViewDelegate: ViewDelegate {
    /// Edge Insets
    public var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)

    public var cardSize: CGSize {
        preferences.posterType == .poster
            ? CGSize(width: 225, height: 337.5)
            : CGSize(width: 548, height: 308.25)
    }

    public var rowHeight: CGFloat {
        var _height = preferences.posterType == .poster ? 340 : 300

        if preferences.showsTitles {
            _height += 100
        }
        return CGFloat(_height)
    }

    /// Title image  aspect ratio
    public var imageAspectRatio: CGFloat {
        preferences.posterType == .poster ? 2 / 3 : 16 / 9
    }
}
