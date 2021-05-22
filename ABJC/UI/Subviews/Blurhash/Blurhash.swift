//
//  Blurhash.swift
//  ABJC
//
//  Created by Noah Kamara on 18.05.21.
//

import SwiftUI

struct Blurhash: View {
    @Environment(\.colorScheme) var colorScheme
    private let blurhash: String?
    private var shouldOverlay: Bool = false
    
    init(_ blurhash: String?) {
        self.blurhash = blurhash
        if let blurhash = blurhash {
            shouldOverlay = UIImage(blurHash: blurhash, size: .init(width: 5, height: 5))?.brightness ?? 0 > 150
        }
    }
    
    var body: some View {
        if let blurhash = blurhash {
            ZStack {
                Image(blurhash, size: .init(width: 2, height: 2), punch: 1)?.resizable()
                    .overlay(colorOverlay)
            }
        } else {
            Blur()
        }
    }
    
    var colorOverlay: some View {
        Rectangle()
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .opacity(shouldOverlay ? 0.5: 0)
    }
}

extension CGImage {
    var brightness: Double {
        get {
            let imageData = self.dataProvider?.data
            let ptr = CFDataGetBytePtr(imageData)
            var x = 0
            var result: Double = 0
            for _ in 0..<self.height {
                for _ in 0..<self.width {
                    let r = ptr![0]
                    let g = ptr![1]
                    let b = ptr![2]
                    result += (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                    x += 1
                }
            }
            let bright = result / Double (x)
            return bright
        }
    }
}
extension UIImage {
    var brightness: Double {
        get {
            return (self.cgImage?.brightness)!
        }
    }
}

//struct Blurhash_Previews: PreviewProvider {
//    static var previews: some View {
//        Blurhash()
//    }
//}
