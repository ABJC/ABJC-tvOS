//
//  CredentialEntryView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI

extension AuthView.ServerSelectionView {
    struct CredentialEntryView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Server Host
        private let host: String
        
        /// Server Port
        private let port: Int
        
        /// Server Path
        private let path: String?
        
        
        /// Credentials: username
        @State var username: String = ""
        
        /// Credentials: password
        @State var password: String = ""
        
        /// Credentials: HTTPS enabled
        @State var isHttpsEnabled: Bool = false
        
        @State var showingAlert: Bool = false
        
        init(_ host: String, _ port: Int, _ path: String?) {
            self.host = host
            self.port = port
            self.path = path
        }
        
        var body: some View {
            VStack {
                Group() {
                    VStack {
                        Text(host)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    TextField("authView.credentialEntryView.username.label", text: self.$username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.username)
                    SecureField("authView.credentialEntryView.password.label", text: self.$password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                    Toggle("authView.credentialEntryView.isUsingHTTPS.label", isOn: $isHttpsEnabled)
                }.frame(width: 400)
                
                Button(action: authorize) {
                    Text("buttons.signin").textCase(.uppercase)
                }
            }
            .navigationTitle("authView.credentialEntryView.title")
        }
        
        func authorize() {
            let server = Jellyfin.Server(host, port, isHttpsEnabled, path)
            let client = Jellyfin.Client()
            
            API.authorize(server, client, username, password) { result in
                switch result {
                    case .success(let jellyfin):
                        // Store Credentials
//                        CredentialStore.save(jellyfin)
                        
                        // Update Session Store
                        session.setJellyfin(jellyfin)
                        
                    case .failure(let error):
                        session.setAlert(
                            .auth,
                            "failed",
                            "\(isHttpsEnabled ? "(HTTPS)":"") \(username)@\(host):\(port)",
                            error
                        )
                }
            }
        }
    }
    
    struct CredentialEntryView_Previews: PreviewProvider {
        static var previews: some View {
            CredentialEntryView("host", 8096, nil)
        }
    }
}
