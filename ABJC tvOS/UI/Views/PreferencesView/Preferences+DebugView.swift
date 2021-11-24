/*
 ABJC - tvOS
 Preferences+DebugView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import ABJCAnalytics
import JellyfinAPI
import SwiftUI

extension PreferencesView {
    struct DebugView: View {
        @ObservedObject var store: PreferencesViewDelegate

        func resetAll() {
            store.preferences.reset()
            store.session.removeAllUsers()
        }

        var body: some View {
            Form {
                ToggleRow("Debug Mode", "Toggle Debug Mode", $store.isDebugEnabled)
                #if DEBUG
                    analyticsSection
                #endif
                Section {
                    Button(action: {
                        store.alert = .init(
                            id: "reset-app-alert",
                            title: "Reset App",
                            message: "This will remove all users & reset all preferences",
                            primaryBtn: .cancel(),
                            secondaryBtn: .destructive(Text("Confirm"), action: resetAll)
                        )
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset App")
                                .bold()
                                .textCase(.uppercase)
                                .foregroundColor(.red)

                            Spacer()
                        }
                    }.accessibilityIdentifier("removeUserBtn")
                }

//                alertsSection
            }
            .navigationBarTitle("General Information")
            .onChange(of: store.isDebugEnabled) { _ in
                store.savePreferences()
            }
        }

        var analyticsSection: some View {
            Section("Analytics") {
                Button("Install Event") {
                    store.app.analytics.send(.installed, with: [:])
                }

                Button("Update Event") {
                    store.app.analytics.send(.updated, with: [:])
                }
            }
        }

        var alertsSection: some View {
            Section("Alerts") {}
        }
    }
}
