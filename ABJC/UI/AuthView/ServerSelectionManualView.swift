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
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Image("logoWithText")
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
                                
                                
                                NavigationLink(
                                    destination: CredentialEntryView(self.host, Int(self.port) ?? 8096, path))
                                {
                                    Text("buttons.continue").textCase(.uppercase)
                                }
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
