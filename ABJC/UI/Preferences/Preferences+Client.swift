//
//  Client.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI

extension PreferencesView {
    struct Client: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var betaflags: Set<PreferenceStore.BetaFlag> = Set<PreferenceStore.BetaFlag>()
        @State var tabs: Set<PreferenceStore.Tabs> = Set<PreferenceStore.Tabs>()
        
        var body: some View {
            Form() {
                Section(header: Label("pref.client.ui.label", systemImage: "uiwindow.split.2x1")) {
                    InfoToggle("pref.client.showstitles.label", "pref.client.showstitles.descr", $session.preferences.showsTitles)
                        .accessibilityIdentifier("showstitles")
                                        
                    Picker("pref.client.postertype.label", selection: $session.preferences.posterType) {
                        ForEach(PreferenceStore.PosterType.allCases, id: \.rawValue) { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }
                    
                    Picker("pref.client.collectiongrouping.label", selection: $session.preferences.collectionGrouping) {
                        ForEach(Grouping.allCases, id: \.rawValue) { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }
                }
                
                Section(header: Label("pref.client.tabs.label", systemImage: "menubar.rectangle")) {
                    List(PreferenceStore.Tabs.allCases, id: \.rawValue) { tab in
                        Button(action: {
                            DispatchQueue.main.async {
                                tabs.toggle(tab)
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading) {
                                    Text(tab.label)
                                        .bold()
                                    Text(tab.description)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .foregroundColor(tabs.contains(tab) ? .primary : .clear)
                            }.padding()
                        }
                    }
                }
                
                Section(header: Label("pref.client.betaflags.label", systemImage: "exclamationmark.triangle.fill")) {
                    List(PreferenceStore.BetaFlag.availableFlags(), id: \.rawValue) { flag in
                        Button(action: {
                            DispatchQueue.main.async {
                                betaflags.toggle(flag)
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading) {
                                    Text(flag.label)
                                        .bold()
                                    Text(flag.description)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .foregroundColor(betaflags.contains(flag) ? .primary : .clear)
                            }.padding()
                        }
                    }
                }
            }
            
            .onAppear(perform: loadSettings)
            .onDisappear(perform: storeSettings)
        }
        
        func loadSettings() {
            DispatchQueue.main.async {
                betaflags = session.preferences.betaflags
                tabs = session.preferences.tabs
            }
        }
        
        func storeSettings() {
            DispatchQueue.main.async {
                session.preferences.betaflags = betaflags
                session.preferences.tabs = tabs
                session.objectWillChange.send()
            }
        }
    }
    
    struct Client_Previews: PreviewProvider {
        static var previews: some View {
            Client()
        }
    }
}
