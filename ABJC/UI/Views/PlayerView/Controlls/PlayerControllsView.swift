/*
 ABJC - tvOS
 PlayerControllsView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct PlayerControllsView: View {
    enum Focus: String {
        case bar
        case audio
    }

    @Environment(\.presentationMode) var presentationMode

    @Namespace var namespace
    @FocusState var focus: Focus?
    @ObservedObject var store: PlayerDelegate

    let hideTimer = Timer.publish(every: 10.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if store.preferences.isDebugEnabled {
                debugView
            }
            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .lastTextBaseline) {
                    itemDescription
                    Spacer()
//                    channelMenus
                }.focusSection()
                playbackBar
                timeLabels
            }
        }
        .onPlayPauseCommand(perform: store.playPauseAction)
        .onLongPressGesture(minimumDuration: 0.01, perform: store.playPauseAction, onPressingChanged: { _ in })
        .background(Color.black.opacity(store.player.state != .playing ? 0.7 : 0))
        .onReceive(hideTimer) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }

    // Playback Item Description
    var itemDescription: some View {
        VStack(alignment: .leading, spacing: 10) {
            if store.item.type ?? "" == ItemType.episode.rawValue {
                Text(store.item.seriesName ?? "Unknown Series")
                Text(store.item.episodeTitle ?? "No Name")
                    .font(.headline)
            } else {
                Text(store.item.name ?? "No Name")
                    .font(.headline)
            }
        }
        .padding(.bottom)
    }

    var playbackBar: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.white)
                .opacity(focus == .bar ? 0.8 : 0.1)

            Rectangle()
                .fill(.regularMaterial)

            Rectangle()
                .fill(focus == .bar ? .white : .secondary)
                .frame(width: min(CGFloat(store.player.position) * 1860, 1860))
                .animation(.linear(duration: store.player.state == .paused ? 0.0 : 0.5), value: store.player.position)
        }
        .frame(width: 1860, height: 15, alignment: .center)
        .clipShape(Capsule(), style: .init(eoFill: false, antialiased: true))
        .focusable()
        .focused($focus, equals: .bar)
        .prefersDefaultFocus(in: namespace)
        .onMove([.right]) {
            store.quickSeekForward()
        }
        .onMove([.left]) {
            store.quickSeekBackward()
        }
        .onMove([.down]) {
            presentationMode.wrappedValue.dismiss()
        }
    }

    var channelMenus: some View {
        HStack {
            Picker(selection: $store.currentAudioTrack) {
                ForEach(store.audioTracks) { track in
                    HStack {
                        Text(track.index.description)
                        Text(track.name)
                    }
                }
            } label: {
                Image(systemName: "waveform")
                    .frame(width: 60, height: 60, alignment: .center)
            }
            .pickerStyle(.segmented)
            .clipShape(Circle())

//            Picker(selection: store.$currentVideoTrack) {
//                <#code#>
//            } label: {
//                Image(systemName: "waveform")
//            }
        }
    }

    /// Time Labels
    var timeLabels: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            // Time Label
            Text(
                store.preferences.isDebugEnabled
                    ? store.playerTime.verboseStringValue
                    : store.playerTime.stringValue
            )

            Spacer()

            // State
            Group {
                switch store.playerState {
                    case .playing: Image(systemName: "play.fill")
                    case .paused: Image(systemName: "pause.fill")
                    case .stopped,
                         .ended: Image(systemName: "stop.fill")
                    case .opening,
                         .buffering: ProgressView()
                    case .esAdded: Text("esAdded")
                    case .error: Image(systemName: "exclamationmark.triangle.fill")
                    default: Image(systemName: "questionmark")
                }
            }
            .animation(.spring(), value: store.playerState)

            Spacer()

            // Remaining Label
            Text(
                store.preferences.isDebugEnabled
                    ? store.playerTimeRemaining.verboseStringValue
                    : store.playerTimeRemaining.stringValue
            )
        }
    }

    var debugView: some View {
        HStack {
            VStack {
                Text("Tracks:").bold()
                Group {
                    PreferencesView.InfoRow("Number Audio Tracks", store.player.numberOfAudioTracks, false)
                    Divider()
                    PreferencesView.InfoRow("Number Video Tracks", store.player.numberOfVideoTracks, false)
                    Divider()
                    PreferencesView.InfoRow("Number Subtitle Tracks", store.player.numberOfSubtitlesTracks, false)
                }
                Group {
                    Divider()
                    PreferencesView.InfoRow(
                        "Video Track",
                        store.player.videoTrackNames.get(Int(store.player.currentVideoTrackIndex)),
                        false
                    )
                    Divider()
                    PreferencesView.InfoRow(
                        "Audio Track",
                        store.player.audioTrackNames.get(Int(store.player.currentAudioTrackIndex)),
                        false
                    )
                    Divider()
                    PreferencesView.InfoRow(
                        "Subtitle Track",
                        store.player.videoSubTitlesNames.get(Int(store.player.currentVideoSubTitleIndex)),
                        false
                    )
                }
            }.frame(width: 500)

            VStack {
                Text("Media: ").bold()
                Group {
                    PreferencesView.InfoRow("State", store.player.media.state.debugDescription, false)
                    Divider()
                    PreferencesView.InfoRow("Media Suitable", store.player.media.isMediaSizeSuitableForDevice, false)
                    Divider()
                    PreferencesView.InfoRow("Video Size", store.player.videoSize, false)
                }
                Group {
                    Divider()
                    PreferencesView.InfoRow("Input Bitrate", store.player.media.inputBitrate, false)
                    Divider()
                    PreferencesView.InfoRow("Demux", store.player.media.demuxBitrate, false)
                    Divider()
                    PreferencesView.InfoRow("Stream Output", store.player.media.streamOutputBitrate, false)
                }
            }.frame(width: 500)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(15, antialiased: true)
        .font(.caption)
    }
}

// struct PlayerControllsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerControllsView(store: .init(.preview))
//    }
// }
