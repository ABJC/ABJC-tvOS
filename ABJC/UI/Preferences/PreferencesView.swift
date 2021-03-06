//
//  PreferencesView.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI

struct PreferencesView: View {
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
    
    @State var showReportAProblem: Bool = false
    @State var showRemoveServerAlert: Bool = false
    var version: Version { session.preferences.version }
    
    var body: some View {
        NavigationView() {
            List() {
                NavigationLink(destination: GeneralInfo()) {
                    Label("pref.general.label", systemImage: "server.rack")
                }.tag(0)
                
                NavigationLink(destination: Client()) {
                    Label("pref.client.label", systemImage: "tv")
                }.tag(1)

                NavigationLink(destination: DebugMenu()) {
                    Label("pref.debugmenu.label", systemImage: "exclamationmark.triangle")
                }.tag(2)
                
//                Button(action: {
//                    self.showReportAProblem.toggle()
//                }) {
//                    HStack {
//                        Spacer()
//                        Text("reportaproblem.title")
//                            .bold()
//                            .textCase(.uppercase)
//
//                        Spacer()
//                    }
//                }
                
                Button(action: {
                    self.session.logout()
                }) {
                    HStack {
                        Spacer()
                        Text("buttons.logout")
                            .bold()
                            .textCase(.uppercase)
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                }
            
            Button(action: {
                showRemoveServerAlert = true
            }) {
                HStack {
                    Spacer()
                    Text("alerts.removeServer.title")
                        .bold()
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                    
                    Spacer()
                }
            }
        }
            
            VStack {
                Image("logo")
                HStack {
                    Text("App Version")
                    Text(version.description)
                }
            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .alert(isPresented: $showRemoveServerAlert, content: {
            Alert(title: Text("alerts.removeServer.title"), message: Text("alerts.removeServer.label"), primaryButton: .destructive(Text("Delete"), action: {
                session.removeServer()
            }), secondaryButton: .cancel())
        })
        
        .fullScreenCover(isPresented: $showReportAProblem) { 
            ReportAProblemView(session)
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
