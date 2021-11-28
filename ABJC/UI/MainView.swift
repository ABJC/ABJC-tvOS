/*
 ABJC - tvOS
 MainView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 21.11.21
 */

import SwiftUI
import GameController




struct GameControllerTest: View {
    @State var directionLabel: String = ""
    @State var sliderValue: Float = 0.5
    @State private var currentRadians: Float = 0
    
    @StateObject var remote: SiriRemoteWheel = .init()
    
    private func controllerConnected(_ note: Notification) {
        
        // Only considering a single controller for simplicity
        guard let controller = GCController.controllers().first else { return }
        
        guard let micro = controller.microGamepad else { return }
        micro.reportsAbsoluteDpadValues = true
        
        micro.dpad.valueChangedHandler = { [self] (pad, x, y) in
            let radius = sqrt(x*x + y*y)
            
            // Test if touch is on wheel
            guard radius > 0.5 else {
                self.directionLabel = ""
                return
            }
            
            return;
            
            print(x, y)
            if (x,y) == (0,0) {
                DispatchQueue.main.async {
                    directionLabel = "⏺"
                }
            }

            // Get the distance from the center of the digitizer to the gesture location
            
            // Discard gestures out of the ring area of Siri Remote
            guard radius > 0.5 else {
                DispatchQueue.main.async {
                    self.directionLabel = "⏺"
                }
                return
            }
            
            withAnimation(.linear(duration: 0.01)) {
                
                // Rotate hintView to the appropriate radians
                let cos = x / radius
                let sin = y / radius
                let radians = atan2(sin, cos)
                
                // Get and log rotation direction
                let normalizedRadians = (radians + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi)
                
                let radiansOffset = normalizedRadians - self.currentRadians
                let normalizedRadiansOffset = (radiansOffset + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi)
                
                DispatchQueue.main.async {
                    if normalizedRadiansOffset > .pi {
                        self.directionLabel = "➡️"
                        self.sliderValue = min(1, self.sliderValue + 0.001)
                    }
                    else {
                        self.directionLabel = "⬅️"
                        self.sliderValue = max(0, self.sliderValue - 0.001)
                    }
                    
                    print(self.directionLabel, sliderValue)
                }
                
                self.currentRadians = normalizedRadians
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .leading) {
                Capsule().fill(.regularMaterial)
                Rectangle().foregroundColor(.white)
                    .frame(width: 800 * CGFloat(remote.value))
            }
            .cornerRadius(10, antialiased: true)
            .frame(width: 800, height: 20, alignment: .center)
            Spacer()
            touchpad.frame(width: 300, height: 300, alignment: .center)
        }
    }
    
    var touchpad: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Circle()
                    .fill(.regularMaterial)
                Circle()
                    .frame(width: 20, height: 20, alignment: .center)
                    .position(x: (150 * remote.touchPosition.x) + 150, y: (150 * -remote.touchPosition.y) + 150)
            }
            .frame(width: 300, height: 300, alignment: .center)
        }
    }
}

struct MainView: View {
    @Environment(\.appConfiguration) var app

    @StateObject var preferences = PreferenceStore.shared
    @StateObject var session = SessionStore.shared

    var body: some View {
        Group {
            if !preferences.hasAnalyticsConsent, !CommandLineArguments().isRunningTests {
                PrivacyDisclaimer(preferences: preferences)
            } else {
                Group {
                    if session.isAuthenticated {
                        LibraryView()
                    } else {
                        AuthenticationView()
                    }
                }.onAppear {
                    if PreferenceStore.shared.isFirstBoot {
                        app.analytics.send(.installed, with: [:])
                        PreferenceStore.shared.isFirstBoot = false
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
