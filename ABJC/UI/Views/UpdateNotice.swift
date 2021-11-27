/*
 ABJC - tvOS
 UpdateNotice.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 27.11.21
 */

import SwiftUI

public enum UpdateNotices: String, Identifiable {
    public var id: String { rawValue }

    case newCoverArt

    var title: LocalizedStringKey {
        switch self {
            case .newCoverArt:
                return "New Cover Art"
        }
    }

    var description: LocalizedStringKey {
        switch self {
            case .newCoverArt:
                return "Wide Posters will be fetched from the ABJC API from now on. This ensures images contain the movie logo or title (like the TV-App). To Enable this go to Preferences > Client > Poster"
        }
    }

    var hasActionBtn: Bool {
        switch self {
            case .newCoverArt:
                return false
        }
    }

    var actionbtnLabel: LocalizedStringKey {
        switch self {
            default:
                return "This Button should not be here"
        }
    }

    func actionBtn(_ store: PreferenceStore) {
        switch self {
            default:
                return
        }
        store.objectWillChange.send()
    }
}

struct UpdateNotice: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var preferences: PreferenceStore
    @State var updateNotice: UpdateNotices

    var body: some View {
        VStack {
            // Logo
            Image("logo_square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)

            Text(updateNotice.title)
                .font(.title)
                .padding(.bottom)

            Text(updateNotice.description)
                .multilineTextAlignment(.center)
                .frame(width: 800)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(10, antialiased: true)

            if updateNotice.hasActionBtn {
                Button(updateNotice.actionbtnLabel) {
                    updateNotice.actionBtn(preferences)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button(updateNotice.hasActionBtn ? "No Thanks" : "Continue") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(width: 1920, height: 1080, alignment: .center)
    }
}
