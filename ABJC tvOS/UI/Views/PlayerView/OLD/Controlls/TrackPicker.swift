/*
 ABJC - tvOS
 TrackPicker.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import SwiftUI

struct TrackPicker: View {
    private let label: LocalizedStringKey
    private let tracks: [Track]
    @Binding var selection: Track

    init(_ label: LocalizedStringKey, _ selection: Binding<Track>, _ tracks: [Track]) {
        self.label = label
        _selection = selection
        self.tracks = tracks
    }

    @State var showPicker: Bool = false

    var body: some View {
        VStack {
            Button {
                self.showPicker.toggle()
            } label: {
                VStack(alignment: .leading) {
                    Text(label)
                    HStack {
                        Text("Track \(selection.index): ")
                        Text(selection.name)
                    }.font(.caption)
                }
            }

            if showPicker {
                ForEach(tracks) { track in
                    Button {
                        self.selection = track
                    } label: {
                        HStack {
                            Text("Track \(selection.index): ")
                            Text(selection.name)
                        }
                    }

                }.animation(.default, value: showPicker)
            }
        }
    }
}

struct TrackPicker_Previews: PreviewProvider {
    static var previews: some View {
        TrackPicker("Track Picker", .constant(.init(index: -1, name: "")), [
            .init(index: -1, name: "Track 1"),
            .init(index: 2, name: "Track 2"),
            .init(index: 3, name: "Track 3")
        ])
    }
}
