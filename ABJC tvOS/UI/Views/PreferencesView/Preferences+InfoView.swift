/*
 ABJC - tvOS
 Preferences+InfoView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import SwiftUI

extension PreferencesView {
    struct InfoView: View {
        @ObservedObject var store: PreferencesViewDelegate

        var body: some View {
            Form {
                Section("System Information") {
                    InfoRow("Name", store.systemInfo?.serverName ?? "ERR")
                    InfoRow("System Architecture", store.systemInfo?.systemArchitecture ?? "ERR")
                    InfoRow("Operating System", store.systemInfo?.operatingSystem ?? "ERR")
                    InfoRow("Identifier", store.systemInfo?.id ?? "ERR")
                    InfoRow("Jellyfin Version", store.systemInfo?.version ?? "ERR")
                }

                Section("Server Configuration") {
                    InfoRow("Local Address", store.systemInfo?.localAddress ?? "ERR")
                    InfoRow("IPv4", store.serverConfiguration?.enableIPV4?.description ?? "ERR")
                    InfoRow("IPv6", store.serverConfiguration?.enableIPV6?.description ?? "ERR")
                    InfoRow("HTTP Port", store.serverConfiguration?.httpServerPortNumber ?? "ERR")
                    InfoRow("HTTPS Port", store.serverConfiguration?.httpsPortNumber ?? "ERR")
                    InfoRow("AutoDiscovery", store.serverConfiguration?.autoDiscovery?.description ?? "ERR")
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
