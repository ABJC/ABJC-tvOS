//
//  CredentialEntryView.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import SwiftUI
import URLImage

extension AuthView.ServerSelectionView {
    struct CredentialEntryView: View {
        @Namespace private var namespace
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var profileImageURL: URL? = nil
        
        /// Credentials: username
        @State var username: String = ""
        
        /// Credentials: password
        @State var password: String = ""
        
        
        @State var showingAlert: Bool = false
        
        @State var isCredentialsFilledIn: Bool = false
        
        var user: APIModels.User? = nil
        
        var jellyfin: Jellyfin? = nil
        
        init(_ jellyfin: Jellyfin?, _ user: APIModels.User? = nil) {
            self.user = user
            self.jellyfin = jellyfin
        }
        
        var body: some View {
            
            ZStack {
                // Sretch frame to whole screen for background color
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(alignment: .center) {
                    Group {
                        profileImageView
                    }.padding(20)
                    
                    
                    VStack {
                        Group() {
                            TextField(LocalizedStringKey("authView.credentialEntryView.username.label"), text: self.$username)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(.username)
                                .prefersDefaultFocus(username.isEmpty, in: namespace)
                                .disabled(user != nil)
                            
                            SecureField("authView.credentialEntryView.password.label", text: self.$password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(.password)
                                .prefersDefaultFocus(!username.isEmpty, in: namespace)
                        }.frame(width: 400)
                        
                        Button(action: authorize) {
                            Text(LocalizedStringKey("buttons.signin")).textCase(.uppercase)
                        }
                        .prefersDefaultFocus(!username.isEmpty && !password.isEmpty, in: namespace)
                    }
                    
                }
            }
            
            .background(
                LinearGradient(
                    gradient: Gradient(colors: Color.backgroundGradient),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all))
            .navigationTitle("authView.credentialEntryView.title")
            .onAppear(perform: setupImageURL)
            
        }
        
        func setupImageURL() {
            if let jellyfin = jellyfin, let user = user {
                username = user.name
                if user.primaryImageTag != nil {
                    self.profileImageURL = API.profileImageURL(jellyfin, user.id)
                }
            }
        }
        
        
        var profileImageView: some View {
            AsyncImg(url: profileImageURL) { image in
                image
                    .renderingMode(.original)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 300, height: 300)
            } placeholder: {
                Image(systemName: user == nil ? "person.fill.badge.plus" : "person.fill")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .scaledToFill()
                    .scaleEffect(0.8)
                    .background(user == nil ? Color.clear : Color.blue)
                    .cornerRadius(20)
            }
        }
        
        func authorize() {
            guard let jellyfin = jellyfin else {
                return
            }
            API.authorize(jellyfin.server, jellyfin.client, username, password) { result in
                switch result {
                    case .success(let jellyfin):
                        session.setJellyfin(jellyfin, true)
                        
                    case .failure(let error):
                        API.logError(method: .authorize, error: error, session: session, in: .credentialEntry)
                        session.setAlert(
                            .auth,
                            "failed",
                            "\(jellyfin.server.https ? "(HTTPS)":"") \(username)@\(jellyfin.server.host):\(jellyfin.server.port)",
                            error
                        )
                }
            }
        }
    }
    
    //    struct CredentialEntryView_Previews: PreviewProvider {
    //        static var previews: some View {
    //            CredentialEntryView()
    //        }
    //    }
}
