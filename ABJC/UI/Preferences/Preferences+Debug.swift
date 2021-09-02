//
//  DebugMenu.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI
import URLImage

extension PreferencesView {
    struct DebugMenu: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        @Environment(\.urlImageService) var urlImageService
        
        
        public init() {}
        
        
        /// ViewBuilder body
        public var body: some View {
            Form() {
                Toggle("pref.debugmenu.debugmode.label", isOn: $session.preferences.isDebugEnabled)
                
                Section(header: Label("pref.debugmenu.images.label", systemImage: "photo.fill")) {
                    Button(action: {
                        urlImageService.fileStore?.removeAllImages()
                        urlImageService.inMemoryStore?.removeAllImages()
                    }) {
                        Text("pref.debugmenu.clearimagecache.label")
                            .textCase(.uppercase)
                    }
                }
                
                Section(header: Label("pref.debugmenu.alerts.label", systemImage: "exclamationmark.bubble")) {
                    Button(action: {
                        session.setAlert(.auth, "test", "Auth Error Alert", nil)
                    }) {
                        Text("pref.debugmenu.alerts.auth")
                            .textCase(.uppercase)
                    }
                    
                    Button(action: {
                        session.setAlert(.api, "test", "API Error Alert", nil)
                    }) {
                        Text("pref.debugmenu.alerts.api")
                            .textCase(.uppercase)
                    }
                    
                    Button(action: {
                        session.setAlert(.playback, "test", "Playback Error Alert", nil)
                    }) {
                        Text("pref.debugmenu.alerts.playback")
                            .textCase(.uppercase)
                    }
                }
            }
        }
    }
    
    struct DebugMenu_Previews: PreviewProvider {
        static var previews: some View {
            DebugMenu()
        }
    }

}
