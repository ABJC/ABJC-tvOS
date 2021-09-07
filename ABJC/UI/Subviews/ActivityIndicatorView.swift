//
//  ActivityIndicatorView.swift
//  ABJC
//
//  Created by Noah Kamara on 11.05.21.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ZStack {
            Blur()
                .edgesIgnoringSafeArea(.all)
            Text(LocalizedStringKey("Pls don't crash 🥺 "))
        }
//        ProgressView()
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
