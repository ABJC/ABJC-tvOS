/*
 ABJC - tvOS
 Preferences+ClientView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

extension PreferencesView {
    struct ClientView: View {
        @ObservedObject
        var store: PreferencesViewDelegate

        var body: some View {
            Form {
                Section(header: Label("User Interface", systemImage: "uiwindow.split.2x1")) {
                    ToggleRow("Always Show Titles", "Show a titles for items", $store.showsTitles)

                    Picker("Poster Type", selection: $store.posterType) {
                        ForEach(PreferenceStore.PosterType.allCases, id: \.rawValue) { value in
                            Label(value.localizedName, systemImage: value.systemImage)
                                .tag(value)
                        }
                    }.accessibilityIdentifier("Poster Type")

                    Picker("Collection Grouping", selection: $store.collectionGrouping) {
                        ForEach(CollectionGrouping.allCases, id: \.rawValue) { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }.accessibilityIdentifier("Collection Grouping")
                }

//                Section(header: Label("Beta Flags", systemImage: "exclamationmark.triangle.fill")) {
//                    List(PreferenceStore.BetaFlag.availableFlags(), id: \.rawValue) { flag in
//                        Button(action: {
//                            DispatchQueue.main.async {
//                                store.betaflags.toggle(flag)
//                            }
//                        }) {
//                            HStack(alignment: .firstTextBaseline) {
//                                VStack(alignment: .leading) {
//                                    Text(flag.label)
//                                        .bold()
//                                    Text(flag.description)
//                                        .font(.callout)
//                                        .foregroundColor(.secondary)
//                                }
//                                Spacer()
//                                Image(systemName: "checkmark")
//                                    .imageScale(.large)
//                                    .foregroundColor(store.betaflags.contains(flag) ? .primary : .clear)
//                            }.padding()
//                        }
//                    }
//                }
            }
            .onChange(of: store.showsTitles) { _ in
                store.savePreferences()
            }
            .onChange(of: store.collectionGrouping) { _ in
                store.savePreferences()
            }
            .onChange(of: store.posterType) { _ in
                store.savePreferences()
            }
            .onChange(of: store.betaflags) { _ in
                store.savePreferences()
            }

            .navigationBarTitle("Client Preferences")
        }
    }

    struct ClientView_Previews: PreviewProvider {
        static var previews: some View {
            ClientView(store: .init())
        }
    }
}
