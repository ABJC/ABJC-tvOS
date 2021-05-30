//
//  ServerUserListView.swift
//  ABJC
//
//  Created by Stephen Byatt on 30/5/21.
//

import SwiftUI
import URLImage

extension AuthView.ServerSelectionView {
    struct ServerUserListView: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        /// Server Host
        private let host: String
        
        /// Server Port
        private let port: Int
        
        /// Server Path
        private let path: String?
        
        
        init(_ host: String, _ port: Int, _ path: String?) {
            self.host = host
            self.port = port
            self.path = path
            
            let isHttpsEnabled = false // work on if need HTTPs
            
            let server = Jellyfin.Server(host, port, isHttpsEnabled, path)
            let client = Jellyfin.Client()
            let user = Jellyfin.User("", "", "")
            jellyfin = Jellyfin(server, user, client)
        }
        
        @State var users = [APIModels.User]()
        
        var jellyfin : Jellyfin
        
        var body: some View {
            ZStack {
                // Sretch frame to whole screen for background color
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                
                VStack{
                    Text("Whos Watching?")
                        .font(.title)
                        .padding(.bottom, 30)
                    HStack {
                        ForEach(users, id: \.id) { user in
                            // Link to manual sign in
                            if user.hasPassword {
                                NavigationLink(
                                    destination: CredentialEntryView(self.host, self.port, path, user.name))
                                {
                                    UserImageBoxView(user, jellyfin)
                                }
                                .buttonStyle(CardButtonStyle())
                                
                            }
                            else {
                                // Sign in without password
                                Button(action: {authorize(user: user)}, label: {
                                    UserImageBoxView(user, jellyfin)
                                })
                                .buttonStyle(CardButtonStyle())
                                
                            }
                        }
                        
                        NavigationLink(
                            destination: CredentialEntryView(self.host, self.port, path))
                        {
                            VStack {
                                Image(systemName: "ellipsis.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .scaleEffect(0.3)
                                    .foregroundColor(Color.init(white: 0.6))
                                Text("buttons.signin")
                                    .textCase(.uppercase)
                                    .padding(.bottom)
                            }
                        }
                        .buttonStyle(CardButtonStyle())
                        .padding()
                    }
                    .padding(.top)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: Color.backgroundGradient),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all))
            .onAppear(perform: fetchPublicUsers)
        }
        
        func fetchPublicUsers(){
            API.publicUsers(jellyfin) { result in
                switch result {
                case .success(let fetchedUsers):
                    users = fetchedUsers
                case .failure(let error):
                    session.setAlert(
                        .auth,
                        "failed",
                        "Public Users: \(jellyfin.server.https ? "(HTTPS)":"") @\(host):\(port)",
                        error
                    )
                }
            }
            
        }
        
        func authorize(user : APIModels.User) {
            let isHttpsEnabled = false // work on if need HTTPs
            
            let server = Jellyfin.Server(host, port, isHttpsEnabled, path)
            let client = Jellyfin.Client()
            
            API.authorize(server, client, user.name, "") { result in
                switch result {
                case .success(let jellyfin):
                    // Store Credentials
                    //CredentialStore.save(jellyfin)
                    
                    // Update Session Store
                    session.setJellyfin(jellyfin)
                    
                case .failure(let error):
                    session.setAlert(
                        .auth,
                        "failed",
                        "\(isHttpsEnabled ? "(HTTPS)":"") \(user.name)@\(host):\(port)",
                        error
                    )
                }
            }
        }
    }
    
    
    struct UserImageBoxView: View {
        
        let user : APIModels.User
        let jellyfin : Jellyfin
        
        init(_ user : APIModels.User, _ jellyfin : Jellyfin) {
            self.user = user
            self.jellyfin = jellyfin
        }
        
        private var profileImageURL: URL?{
            if let _ = user.primaryImageTag {
                return API.profileImageURL(jellyfin, user.id)
            }
            return nil
        }
        
        var body: some View {
            VStack {
                image
                    .overlay(Image(systemName: user.hasPassword ? "lock" : "lock.open" ).padding(2), alignment: .bottomLeading)
                Text(user.name)
                    .padding(.bottom)
            }
        }
        
        /// URLImage
        private var image: some View {
            if let url = profileImageURL {
                return AnyView(URLImage(
                    url,
                    empty: { placeholder },
                    inProgress: { _ in placeholder },
                    failure: { _, _ in placeholder }
                ) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 300, height: 300)
                })
            }
            return AnyView(placeholder)
        }
        
        /// Placeholder for loading URLImage
        private var placeholder: some View {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 300, height: 300)
                .scaledToFill()
                .scaleEffect(0.8)
                .background(Color.blue)
        }
    }
    
}
