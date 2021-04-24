//
//  MainView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

struct MainView: View {
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Group() {
            if session.jellyfin == nil {
                AuthView().environmentObject(session)
            } else {
                LibraryView().environmentObject(session)
            }
        }
        
        .alert(item: $session.alert) { (alert) -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.description),
                dismissButton: .default(Text("buttons.ok"))
            )
        }
        
        .fullScreenCover(item: $session.itemFocus) { item in
            LibraryView.ItemPage(item)
        }
        
        .fullScreenCover(item: $session.itemPlaying) { item in
            MediaPlayerView(item)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
