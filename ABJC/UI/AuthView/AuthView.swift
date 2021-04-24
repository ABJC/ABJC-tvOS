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
            if firstTryFailed {
                ServerSelectionView()
            } else {
                ProgressView()
            }
        }
        .onAppear(perform: checkCredentialStore)
    }
    
    func checkCredentialStore() {
        session.loadCredentials() { result in
            self.firstTryFailed = true
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
