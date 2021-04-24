//
//  Preferences+GeneralInfo.swift
//  ABJC
//
//  Created by Noah Kamara on 23.04.21.
//

import SwiftUI

extension PreferencesView {
    
    struct GeneralInfo: View {
        
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        
        @State var serverInfo: APIModels.SystemInfo? = nil
        @State var libraryInfo: APIModels.ItemCounts? = nil
        @State var userInfo: APIModels.User? = nil
        
        var body: some View {
            Form() {
                Section(header: Label("pref.serverinfo.label", systemImage: "server.rack")) {
                    if let data = serverInfo {
                        if let server = session.jellyfin?.server {
                            InfoRow("pref.serverinfo.address", "\(server.https ? "[HTTPS]" : "[HTTP]") \(server.host):\(server.port)\(server.path != nil ? "/"+server.path! : "")")
                        }
                        
                        InfoRow("pref.serverinfo.servername", data.serverName)
                        InfoRow("pref.serverinfo.version", data.version)
                        InfoRow("pref.serverinfo.id", data.serverId)
                        InfoRow("pref.serverinfo.os", data.operatingSystemName)
                        InfoRow("pref.serverinfo.architecture", data.systemArchitecture)
                    } else {
                        ProgressView()
                    }
                }
                
                Section(header: Label("pref.libraryinfo.label", systemImage: "books.vertical")) {
                    if let data = libraryInfo {
                        InfoRow("pref.libraryinfo.total", data.items)
                        InfoRow("pref.libraryinfo.movies", data.movies)
                        InfoRow("pref.libraryinfo.series", data.series)
                        InfoRow("pref.libraryinfo.episodes", data.episodes)
                    } else {
                        ProgressView()
                    }
                }
                
                Section(header: Label("pref.userinfo.label", systemImage: "person.circle")) {
                    if let data = userInfo {
                        InfoRow("pref.userinfo.name", data.name)
                        InfoRow("pref.userinfo.id", data.id)
                    } else {
                        ProgressView()
                    }
                }
            }.onAppear(perform: load)
        }
        
        
        /// Loads ServerInfo
        func load() {
            API.systemInfo(session.jellyfin!) { result in
                switch result {
                    case .success(let data): self.serverInfo = data
                    case .failure(let error): print(error)
                }
            }
            
            
            API.itemCounts(session.jellyfin!) { result in
                switch result {
                    case .success(let data): self.libraryInfo = data
                    case .failure(let error): print(error)
                }
            }
            
            API.currentUser(session.jellyfin!) { result in
                switch result {
                    case .success(let data): self.userInfo = data
                    case .failure(let error): print(error)
                }
            }
        }
    }
}
