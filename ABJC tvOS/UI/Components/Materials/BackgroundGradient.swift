//
//  BackgroundGradient.swift
//  BackgroundGradient
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI

extension View {
    func background() -> some View {
        background(BackgroundViews.gradient)
    }
}

enum BackgroundViews {
    static var gradient: some View {
        LinearGradient(colors: [Color(uiColor: .init(red: 0.003, green: 0.095, blue: 0.310, alpha: 1))],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    static var blur: some View {
        Blur()
            .edgesIgnoringSafeArea(.all)
    }
}

// struct BackgroundGradient_Previews: PreviewProvider {
//    static var previews: some View {
//        BackgroundGradient<LinearGradient>()
//    }
// }
