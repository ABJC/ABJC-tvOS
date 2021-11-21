/*
 ABJC - tvOS
 PreferencesView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 19.11.21
 */

import SwiftUI

struct PreferencesView: View {
    @StateObject var store: PreferencesViewDelegate = .init()
    @State var showReportAProblem: Bool = false

    var body: some View {
        List {
            NavigationLink(destination: { InfoView(store: store) }) {
                Label("General Information", systemImage: "server.rack")
            }
            .tag(0)
            .accessibilityIdentifier("infoViewLink")

            NavigationLink(destination: { ClientView(store: store) }) {
                Label("Client", systemImage: "tv")
            }
            .tag(1)
            .accessibilityIdentifier("clientViewLink")

            NavigationLink(destination: { DebugView(store: store) }) {
                Label("Debugging", systemImage: "exclamationmark.triangle")
            }
            .tag(2)
            .accessibilityIdentifier("debugViewLink")

            Button(action: {
                showReportAProblem.toggle()
            }) {
                HStack {
                    Spacer()
                    Text("Send Feedback")
                        .bold()
                        .textCase(.uppercase)

                    Spacer()
                }
            }.accessibilityIdentifier("sendFeedbackBtn")

            Button(action: store.switchUser) {
                HStack {
                    Spacer()
                    Text("Switch User")
                        .bold()
                        .textCase(.uppercase)

                    Spacer()
                }
            }.accessibilityIdentifier("switchUserBtn")

            Button(action: {
                store.alert = .init(
                    id: "remove-user-alert",
                    title: "Remove User",
                    message: "If you remove this user, you'll have to enter your credentials again to sign back in.",
                    primaryBtn: .cancel(),
                    secondaryBtn: .destructive(Text("Confirm"), action: store.removeUser)
                )
            }) {
                HStack {
                    Spacer()
                    Text("Remove User")
                        .bold()
                        .textCase(.uppercase)
                        .foregroundColor(.red)

                    Spacer()
                }
            }.accessibilityIdentifier("removeUserBtn")
        }
        .onAppear(perform: store.onAppear)
        .onDisappear(perform: store.onDisappear)
        .alert(item: $store.alert) { alert in
            alert.alert()
        }
        .fullScreenCover(isPresented: $showReportAProblem) {} content: {
            ReportAProblemView()
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
