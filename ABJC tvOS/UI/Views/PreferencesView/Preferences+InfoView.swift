//
//  Preferences+InfoView.swift
//  Preferences+InfoView
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

extension PreferencesView {
    struct InfoView: View {
        @ObservedObject var store: PreferencesViewDelegate
        
        var body: some View {
            Form {
                Section("System Information") {
                    InfoRow("Name", store.systemInfo?.serverName ?? "")
                    InfoRow("System Architecture", store.systemInfo?.systemArchitecture ?? "")
                    InfoRow("Operating System", store.systemInfo?.operatingSystem ?? "")
                    InfoRow("Identifier", store.systemInfo?.id ?? "")
                    InfoRow("Jellyfin Version", store.systemInfo?.version ?? "")
                }
                
                Section("Server Configuration") {
                    InfoRow("Local Address", store.systemInfo?.localAddress ?? "")
                    InfoRow("IPv6", store.serverConfiguration?.enableIPV4 ?? false)
                    InfoRow("IPv6", store.serverConfiguration?.enableIPV6 ?? false)
                    
                    InfoRow("HTTP Port", store.serverConfiguration?.httpServerPortNumber ?? "")
                    InfoRow("HTTPS Port", store.serverConfiguration?.httpsPortNumber ?? "")
                    InfoRow("AutoDiscovery", store.serverConfiguration?.autoDiscovery ?? false)
                }
            }
            .onAppear {
                store.loadItemCounts()
                store.loadSystemInfo()
                store.loadServerConfiguration()
            }
            .navigationBarTitle("General Information")
        }
    }
    
    struct InfoView_Previews: PreviewProvider {
        static var previews: some View {
            InfoView(store: .init())
        }
    }
}
