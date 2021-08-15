//
//  AuthView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

struct AuthView: View {
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    /// First Authentification Try failed
    @State var firstTryFailed: Bool = false
    
    var body: some View {
        
        NavigationView() {
            ServerSelectionView()
        }
        
        
        // Present Alerts if any are pending
        .alert(item: $session.alert) { (alert) -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.description),
                dismissButton: .default(Text("buttons.ok"))
            )
        }
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
