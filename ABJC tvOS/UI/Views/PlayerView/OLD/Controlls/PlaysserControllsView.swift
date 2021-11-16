/// *
// ABJC - tvOS
// PlayerControllsView.swift
//
// ABJC is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright 2021 Noah Kamara & ABJC Contributors
// Created on 08.10.21
// */
//
// import AVFoundation
// import SwiftUI
//
// struct PlayerControllsView: View {
//    @Environment(\.presentationMode)
//    var presentationMode
//
//    @ObservedObject
//    var store: PlayerViewDelegate
//    let hideTimer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        ZStack {
//            Group {
//                Color.black
//                    .edgesIgnoringSafeArea(.all)
//                    .opacity(store.player.state == .paused ? 0.7 : 0)
//
//                Image(systemName: store.player.state == .playing ? "play.fill" : "pause.fill")
//                    .resizable()
//                    .aspectRatio(1, contentMode: .fit)
//                    .frame(width: 60, height: 60, alignment: .center)
//                    .imageScale(.large)
//                    .opacity(store.player.state == .paused ? 1 : 0)
//                    .animation(.spring(), value: store.player.state)
//            }
//
//            VStack {
//                HStack {
//                    TrackPicker("Video Track", $store.currentVideoTrack, store.player.videoTracks.sorted())
//                    TrackPicker("Audio Track", $store.currentAudioTrack, store.player.audioTracks.sorted())
//                }
//                if store.preferences.isDebugEnabled {
//                    debugView
//                }
//                Spacer()
//                PlaybackBar()
//                    .focusable()
//                    .onPlayPauseCommand(perform: store.playPause)
//                    .onMoveCommand(perform: store.onMoveCommand)
//                    .onSwipeLeft(store.quickSeekForward)
//                    .onSwipeRight(store.quickSeekBackward)
//                    .onSwipeUp { store.showsControlls = true }
//                    .onSwipeDown { store.showsControlls = false }
//            }.padding(80)
//        }
//        .onReceive(hideTimer) { _ in
//            if self.store.state == .paused {
//                return
//            }
//            self.store.showsControlls = false
//        }
//        .onAppear {
//            print("SHOWING CONTROLLS")
//        }
//        .onChange(of: store.showsControlls) { value in
//            if !value {
//                presentationMode.wrappedValue.dismiss()
//            }
//        }
//    }
//
//    var debugView: some View {
//        HStack {
//            VStack {
//                Text("Tracks:").bold()
//                Group {
//                    PreferencesView.InfoRow("Number Audio Tracks", store.player.numberOfAudioTracks, false)
//                    Divider()
//                    PreferencesView.InfoRow("Number Video Tracks", store.player.numberOfVideoTracks, false)
//                    Divider()
//                    PreferencesView.InfoRow("Number Subtitle Tracks", store.player.numberOfSubtitlesTracks, false)
//                }
//                Group {
//                    Divider()
//                    PreferencesView.InfoRow(
//                        "Video Track",
//                        store.player.videoTrackNames.get(Int(store.player.currentVideoTrackIndex)),
//                        false
//                    )
//                    Divider()
//                    PreferencesView.InfoRow(
//                        "Audio Track",
//                        store.player.audioTrackNames.get(Int(store.player.currentAudioTrackIndex)),
//                        false
//                    )
//                    Divider()
//                    PreferencesView.InfoRow(
//                        "Subtitle Track",
//                        store.player.videoSubTitlesNames.get(Int(store.player.currentVideoSubTitleIndex)),
//                        false
//                    )
//                }
//            }.frame(width: 500)
//                .font(.caption)
//
//            VStack {
//                Text("Media: ").bold()
//                Group {
//                    PreferencesView.InfoRow("State", store.player.media.state.debugDescription, false)
//                    Divider()
//                    PreferencesView.InfoRow("Media Suitable", store.player.media.isMediaSizeSuitableForDevice, false)
//                    Divider()
//                    PreferencesView.InfoRow("Video Size", store.player.videoSize, false)
//                }
//                Group {
//                    Divider()
//                    PreferencesView.InfoRow("Input Bitrate", store.player.media.inputBitrate, false)
//                    Divider()
//                    PreferencesView.InfoRow("Demux", store.player.media.demuxBitrate, false)
//                    Divider()
//                    PreferencesView.InfoRow("Stream Output", store.player.media.streamOutputBitrate, false)
//                }
//            }.frame(width: 500)
//        }
//        .padding()
//        .background(.regularMaterial)
//        .cornerRadius(15, antialiased: true)
//    }
// }
//
//// struct PlayerControllsView_Previews: PreviewProvider {
////    static var previews: some View {
////        PlayerControllsView(store: .init(.preview))
////    }
//// }
