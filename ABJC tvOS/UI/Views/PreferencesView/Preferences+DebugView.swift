//
//  Preferences+DebugView.swift
//  Preferences+DebugView
//
//  Created by Noah Kamara on 14.09.21.
//

import SwiftUI
import ABJCAnalytics
import JellyfinAPI

extension PreferencesView {
    struct DebugView: View {
        @ObservedObject
        var store: PreferencesViewDelegate
        
        var body: some View {
            Form {
                #if DEBUG
                analyticsSection
                #endif
            }
            .navigationBarTitle("General Information")
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
    }
}
