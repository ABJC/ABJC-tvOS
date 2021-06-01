//
//  MainView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI


/// Main View Container
struct MainView: View {
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Group() {
            // Show Authentication if sessionStore.jellyfin is nil
            if session.jellyfin == nil {
                AuthView().environmentObject(session)
            } else {
                LibraryView().environmentObject(session)
            }
        }
        
        // Present Alerts if any are pending
        .alert(item: $session.alert) { (alert) -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.description),
                dismissButton: .default(Text("buttons.ok"))
            )
        }
        
        // Present Item Detail view when focus is set
        .fullScreenCover(item: $session.itemFocus) { item in
            LibraryView.ItemPage(item)
                .environmentObject(session)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
