/*
 ABJC - tvOS
 MainView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 07.10.21
 */

import SwiftUI

struct MainView: View {
    @Environment(\.appConfiguration)
    var app

    @StateObject
    var session = SessionStore.shared

    var body: some View {
        Group {
            if session.isAuthenticated {
                LibraryView()
            } else {
                AuthenticationView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
