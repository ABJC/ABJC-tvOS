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
    
    @State var isAuthenticating: Bool = true
    
    func checkCredentialStore() {
        session.loadCredentials() { didSucceed in
            isAuthenticating = false
        }
    }
    
    var body: some View {
        ZStack() {
            if self.isAuthenticating {
                // Client is still authenticating
                ProgressView()
            } else if session.loggedIn {
                // If Logged in - Proceed to Library
                LibraryView().environmentObject(session)
            } else if session.loggedIn {
                
            } else if session.jellyfin != nil {
                // Client has credentials in store
                ServerUserListView(jellyfin: session.jellyfin).environmentObject(session)
            } else {
                // Client has no credentials in store
                AuthView().environmentObject(session)
            }
        }
        .onAppear(perform: checkCredentialStore)
        
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
