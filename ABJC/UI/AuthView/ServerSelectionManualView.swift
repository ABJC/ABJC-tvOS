//
//  ServerSelectionManView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

extension AuthView.ServerSelectionView {
    struct ManualView: View {
        /// Server Host
        @State var host: String = ""
        
        /// Server Port
        @State var port: String = "8096"
        
        /// Server Path
        @State var path: String = ""
        
        /// HTTPS enabled
        @State var isHttpsEnabled: Bool = false
        
        @State var serverSelected = false
        
        @State private var jellyfin: Jellyfin? = nil
        
        
        var body: some View {
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Image("logo_wide")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.75)
                    }
                    .frame(width: geometry.size.width * 1/2)
                    
                    VStack(alignment: .center) {
                        VStack {
                            HStack(spacing: 5) {
                                Spacer()
                                    .frame(width: 200)
                                Text("authView.serverSelection.title")
                                    .font(.title2).bold()
                                Spacer()
                                    .frame(width: 200)
                                
                            }
                            Group {
                                TextField("authView.serverSelection.host.label", text: self.$host)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                
                                TextField("authView.serverSelection.port.label", text: self.$port)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.oneTimeCode)
                                    .keyboardType(.numberPad)
                                
                                TextField("authView.serverSelection.port.path", text: self.$path)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                
                                Toggle("authView.credentialEntryView.isUsingHTTPS.label", isOn: $isHttpsEnabled)
                                
                                Button {
                                    var path : String? = nil
                                    
                                    if !self.path.isEmpty {
                                        path = self.path
                                        // Ensure users have not entered a '/'
                                        if path!.contains("/") {
                                            path?.removeFirst()
                                        }
                                    }
                                    
                                    let server = Jellyfin.Server(host, Int(port)!, isHttpsEnabled, path)
                                    let client = Jellyfin.Client()
                                    let user = Jellyfin.User("", "", "")
                                    self.jellyfin = Jellyfin(server, user, client)
                                    self.serverSelected = true
                                    
                                } label: {
                                    Text("buttons.continue").textCase(.uppercase)
                                }
                                .background(
                                    NavigationLink(
                                        destination: CredentialEntryView(jellyfin),
                                        isActive: $serverSelected)
                                    {
                                        EmptyView()
                                    }
                                    .buttonStyle(PlainButtonStyle()))
                                
                            }
                        }
                        .frame(maxHeight: .infinity)
                        
                    }
                    .frame(width: geometry.size.width * 1/2)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: Color.backgroundGradient),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all))
            
            
        }
    }
    
    struct ServerSelectionManView_Previews: PreviewProvider {
        static var previews: some View {
            ManualView()
        }
    }
}

