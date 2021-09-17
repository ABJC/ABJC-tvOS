//
//  PlayerControllsView.swift
//  PlayerControllsView
//
//  Created by Noah Kamara on 14.09.21.
//

import SwiftUI

struct PlayerControllsView: View {
    @EnvironmentObject
    var store: PlayerViewDelegate
    let hideTimer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Spacer()
            PlaybackBar()
        }
        .padding(40)
        .onReceive(hideTimer) { _ in
            self.store.showsControlls = false
        }
    }
}

struct PlayerControllsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControllsView()
    }
}
