//
//  Blurhash.swift
//  ABJC
//
//  Created by Noah Kamara on 18.05.21.
//

import SwiftUI

struct Blurhash: View {
    private let blurhash: String?
    
    init(_ blurhash: String?) {
        self.blurhash = blurhash
    }
    
    var body: some View {
        if let blurhash = blurhash {
            Image(blurhash, size: .init(width: 2, height: 2), punch: 1)?.resizable()
        } else {
            Blur()
        }
    }
}

//struct Blurhash_Previews: PreviewProvider {
//    static var previews: some View {
//        Blurhash()
//    }
//}
