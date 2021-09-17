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
        var val = 0
        var result: Double = 0
        for _ in 0 ..< height {
            for _ in 0 ..< width {
                let red = ptr![0]
                let green = ptr![1]
                let blue = ptr![2]
                result += (0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue))
                val += 1
            }
        }
        let bright = result / Double(val)
        return bright
    }
}

extension UIImage {
    var brightness: Double {
        return (cgImage?.brightness)!
    }
}
