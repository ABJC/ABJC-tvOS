//
//  ImageBrightness.swift
//  ImageBrightness
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

extension CGImage {
    var brightness: Double {
        let imageData = dataProvider?.data
        let ptr = CFDataGetBytePtr(imageData)
        var x = 0
        var result: Double = 0
        for _ in 0 ..< height {
            for _ in 0 ..< width {
                let r = ptr![0]
                let g = ptr![1]
                let b = ptr![2]
                result += (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                x += 1
            }
        }
        let bright = result / Double(x)
        return bright
    }
}

extension UIImage {
    var brightness: Double {
        return (cgImage?.brightness)!
    }
}
