//
//  ServerSelectionView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

extension AuthView {
    struct ServerSelectionView: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Servers Discovered By ServerLookup
        @State var servers: [ServerLocator.ServerLookupResponse] = []
        
        /// ServerLocator
        private let locator: ServerLocator = ServerLocator()
        
        var body: some View {
            VStack
            {
                
                ScrollView(.horizontal) {
                    
                    // Automatic Server Selection
                    LazyHStack(alignment: .center)
                    {
                        NavigationLink(destination: ManualView())
                        {
                            ServerCardView("authView.serverSelection.manual.label",
                                           "authView.serverSelection.manual.descr")
                        }
                        
                        
                        // Manual Server Selection
                        ForEach(self.servers, id:\.id)
                        { server in
                            NavigationLink(
//                                destination: CredentialEntryView(server.host, Int(server.port), nil))
                                destination: ServerUserListView(server.host, Int(server.port), nil))
                            {
                                ServerCardView(server)
                            }
                        }
                    }
                }
//                .onLongPressGesture {
//                    DispatchQueue.main.async {
//                        session.preferences.isDebugEnabled.toggle()
//                        if session.preferences.isDebugEnabled {
//                            session.alert = AlertError("pref.debugmode.title", "pref.debugmode.enabled")
//                        } else {
//                            session.alert = AlertError("pref.debugmode.title", "pref.debugmode.disabled")
//                        }
//                    }
//                }
            }
            .onAppear(perform: discover)
            .navigationTitle("authView.serverSelection.title")
        }
        
        /// Discover Servers
        func discover() {
            locator.locateServer { (server) in
                if server != nil {
                    if !servers.contains(server!) {
                        servers.append(server!)
                    }
                }
            }
        }
    }

    struct ServerSelectionView_Previews: PreviewProvider {
        static var previews: some View {
            ServerSelectionView()
        }
    }
}
