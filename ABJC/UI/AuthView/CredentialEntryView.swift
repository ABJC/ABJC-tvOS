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
           
            GeometryReader { geometry in
                HStack {
                    VStack {
                        if profileImageURL != nil {
                            profileImageView
                        }
                        else
                        {
                            personImageView
                        }
                    }
                    .frame(width: geometry.size.width * 1/2)
                    
                    VStack(alignment: .center) {
        
                        VStack {
                            Group() {
                                TextField("authView.credentialEntryView.username.label", text: self.$username)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.username)
                                    .prefersDefaultFocus(username == "", in: namespace)
                                SecureField("authView.credentialEntryView.password.label", text: self.$password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.password)
                                    .prefersDefaultFocus(username != "", in: namespace)

                                
                            }.frame(width: 400)
                            
                            Button(action: authorize) {
                                Text("buttons.signin").textCase(.uppercase)
                            }
                            .prefersDefaultFocus(username != "" && password != "", in: namespace)
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
            .navigationTitle("authView.credentialEntryView.title")
            .onAppear(perform: setupImageURL)
            
        }
        
        func setupImageURL() {
            if let jellyfin = jellyfin, let user = user {
                self.profileImageURL = API.profileImageURL(jellyfin, user.id)
                username = user.name
            }
        }
        
        var personImageView: some View {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 500, height: 500)
                .scaledToFill()
        }
        
        
        var profileImageView: some View {
            if let url = profileImageURL {
                return AnyView(URLImage(
                    url,
                    empty: { personImageView },
                    inProgress: { _ in ProgressView() },
                    failure: { _, _ in personImageView }
                ) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .cornerRadius(20)
                        .frame(width: 500, height: 500)
                })
            }
            else {
                return AnyView(personImageView)
            }
            
        }
        
        func authorize() {
            guard let jellyfin = jellyfin else {
                return
            }
            API.authorize(jellyfin.server, jellyfin.client, username, password) { result in
                switch result {
                case .success(let jellyfin):
                    session.setJellyfin(jellyfin)
                    
                case .failure(let error):
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
