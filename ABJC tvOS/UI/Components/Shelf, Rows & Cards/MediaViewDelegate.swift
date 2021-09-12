//
//  ShelfDelegate.swift
//  ShelfDelegate
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI
import JellyfinAPI

class MediaViewDelegate: ViewDelegate {
    /// Edge Insets
    public var edgeInsets = EdgeInsets(top: 20, leading: 80, bottom: 50, trailing: 80)
    
    public var cardSize: CGSize {
        return preferences.posterType == .poster
        ? CGSize(width: 225, height: 337.5)
        : CGSize(width: 548, height: 308.25)
    }
    
    
    public var rowHeight: CGFloat {
        var _height = preferences.posterType == .poster ? 340 : 300
        
        if preferences.showsTitles
        {
            _height += 100
        }
        return CGFloat(_height)
    }
    
    /// Title image  aspect ratio
    public var imageAspectRatio: CGFloat {
        return preferences.posterType == .poster ? 2/3 : 16/9
    }
}
