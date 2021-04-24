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
        @State var path: String? = nil
        
        var body: some View {
            VStack {
                Group() {
                    TextField("authView.serverSelection.host.label", text: self.$host)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    TextField("authView.serverSelection.port.label", text: self.$port)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                }.frame(width: 400)
                
                NavigationLink(
                    destination: CredentialEntryView(self.host, Int(self.port) ?? 8096, path))
                {
                    Text("buttons.continue").textCase(.uppercase)
                }
            }
        }
    }

    struct ServerSelectionManView_Previews: PreviewProvider {
        static var previews: some View {
            ManualView()
        }
    }
}
