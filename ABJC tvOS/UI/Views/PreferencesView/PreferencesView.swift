/*
 ABJC - tvOS
 PreferencesView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import SwiftUI

struct PreferencesView: View {
    @StateObject
    var store: PreferencesViewDelegate = .init()

    var body: some View {
        List {
            NavigationLink(destination: InfoView(store: store)) {
                Label("General Information", systemImage: "server.rack")
            }
            .tag(0)
            .accessibilityIdentifier("infoViewLink")

            NavigationLink(destination: ClientView(store: store)) {
                Label("Client", systemImage: "tv")
            }
            .tag(1)
            .accessibilityIdentifier("clientViewLink")

            NavigationLink(destination: DebugView(store: store)) {
                Label("Debugging", systemImage: "exclamationmark.triangle")
            }
            .tag(2)
            .accessibilityIdentifier("debugViewLink")

            //                Button(action: {
            //                    self.showReportAProblem.toggle()
            //                }) {
            //                    HStack {
            //                        Spacer()
            //                        Text("Send Feedback")
            //                            .bold()
            //                            .textCase(.uppercase)
            //
            //                        Spacer()
            //                    }
            //                }

            //                Button(action: {
            //                    self.session.logout()
            //                }) {
            //                    HStack {
            //                        Spacer()
            //                        Text(LocalizedStringKey("buttons.logout"))
            //                            .bold()
            //                            .textCase(.uppercase)
            //                            .foregroundColor(.red)
            //
            //                        Spacer()
            //                    }
            //                }

            //                Button(action: {
            //                    showRemoveServerAlert = true
            //                }) {
            //                    HStack {
            //                        Spacer()
            //                        Text(LocalizedStringKey("alerts.removeServer.title"))
            //                            .bold()
            //                            .textCase(.uppercase)
            //                            .foregroundColor(.red)
            //
            //                        Spacer()
            //                    }
            //                }
        }
        .onAppear(perform: store.onAppear)
        .onDisappear(perform: store.onDisappear)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
