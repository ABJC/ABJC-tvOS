/*
 ABJC - tvOS
 PlayerControllsView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

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
