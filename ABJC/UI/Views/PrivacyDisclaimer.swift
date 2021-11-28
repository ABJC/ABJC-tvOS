/*
 ABJC - tvOS
 PrivacyDisclaimer.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct PrivacyDisclaimer: View {
    @ObservedObject var preferences: PreferenceStore

    private let disclaimerText: LocalizedStringKey = """
    ABJC collects usage data to help with development including:

    - Device Model
    - App & OS-Version
    - In-App Preferences
    - Jellyfin API & Other Errors

    No identifiable data is collected.
    Your API-Keys & Servers are stored locally and never leave your device.
    All Data is tied to an ID that is generated on each install.
    """
    var body: some View {
        ZStack {
            BackgroundViews.gradient
                .edgesIgnoringSafeArea(.all)
            VStack {
                // Logo
                Image("logo_square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)

                Text("Privacy & Analytics")
                    .font(.title)
                    .padding(.bottom)

                Spacer()

                Text(disclaimerText)
                    .multilineTextAlignment(.center)
                    .frame(width: 800)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10, antialiased: true)

                Button("Accept & Continue") {
                    preferences.hasAnalyticsConsent = true
                }
            }.padding(80)
        }
        .frame(width: 1920, height: 1080, alignment: .center)
    }
}

struct PrivacyDisclaimer_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyDisclaimer(preferences: .shared)
    }
}
