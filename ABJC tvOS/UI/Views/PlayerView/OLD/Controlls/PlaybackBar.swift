/*
 ABJC - tvOS
 PlaybackBar.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import SwiftUI

struct PlaybackBar: View {
    @EnvironmentObject
    var store: PlayerViewDelegate

    private let barHeight: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            itemDescription
            progressBar
            bottomRow
        }
    }

    var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().foregroundStyle(Material.ultraThin)
                Capsule()
                    .frame(width: min(CGFloat(store.player.position) * geo.size.width, geo.size.width))
                    .animation(.spring(), value: 0.5)
            }
        }
        .frame(height: barHeight, alignment: .center)
    }

    var bottomRow: some View {
        HStack(alignment: .center) {
            Text(toTimeLabel(store.time / 1000))
            stateLabel.padding(.leading, 10)
            Spacer()
            Text(toTimeLabel(store.timeRemaining / 1000))
        }
    }

    func toTimeLabel(_ duration: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [.hour, .minute, .second] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [.pad] // Pad with zeroes where appropriate for the locale
        let formattedDuration = formatter.string(from: .init(duration))
        return formattedDuration ?? "00:00:00"
    }

    var stateLabel: some View {
        Group {
            switch store.state {
                case .playing: Image(systemName: "play.fill")
                case .stopped,
                     .ended: Image(systemName: "stop.fill")
                case .opening,
                     .buffering: ProgressView()
                case .esAdded: Text("esAdded")
                case .error: Image(systemName: "exclamationmark.triangle.fill")
                default: Image(systemName: "questionmark.fill")
            }
        }
    }

    var itemDescription: some View {
        VStack(alignment: .leading, spacing: 10) {
            if store.item.type ?? "" == ItemType.episode.rawValue {
                Text(store.item.seriesName ?? "Episode")
            }
            Text("Episode XX")
            Text(store.item.name ?? "No Name")
                .font(.headline)
        }
    }
}

struct PlaybackBar_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackBar()
    }
}
