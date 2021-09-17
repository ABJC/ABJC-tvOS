//
//  PreferencesView.swift
//  PreferencesView
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

struct PreferencesView: View {
    @StateObject
    var store: PreferencesViewDelegate = .init()

    var body: some View {
        List {
            NavigationLink(destination: InfoView(store: store)) {
                Label("General Information", systemImage: "server.rack")
            }.tag(0)

            NavigationLink(destination: ClientView(store: store)) {
                Label("Client", systemImage: "tv")
            }.tag(1)

                NavigationLink(destination: DebugView(store: store)) {
                    Label("Debugging", systemImage: "exclamationmark.triangle")
                }.tag(2)

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
