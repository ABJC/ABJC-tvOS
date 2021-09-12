//
//  MainView.swift
//  ABJC tvOS
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI

struct MainView: View {
    @Environment(\.appConfiguration) var app
    
    @StateObject var session = SessionStore.shared
    
    var body: some View {
        if session.isAuthenticated {
            LibraryView()
        } else {
            AuthenticationView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
