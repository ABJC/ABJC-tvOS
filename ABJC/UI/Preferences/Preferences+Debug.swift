//
//  DebugMenu.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import SwiftUI
import URLImage


extension PreferencesView {
    struct DebugMenu: View {
        /// SessionStore EnvironmentObject
        @EnvironmentObject var session: SessionStore
        @Environment(\.urlImageService) var urlImageService
        
        @State var showsDetailedReportPrompt: Bool = false
        
        public init() {}
        
        
        /// ViewBuilder body
        public var body: some View {
            Form() {
                Toggle("pref.debugmenu.debugmode.label", isOn: $session.preferences.isDebugEnabled)
                
                Section(header: Label("pref.debugmenu.images.label", systemImage: "photo.fill")) {
                    Button(action: {
                        urlImageService.fileStore?.removeAllImages()
                        urlImageService.inMemoryStore?.removeAllImages()
                    }) {
                        Text(LocalizedStringKey("pref.debugmenu.clearimagecache.label"))
                            .textCase(.uppercase)
                    }
                }
                
                Section(header: Label("pref.debugmenu.alerts.label", systemImage: "exclamationmark.bubble")) {
                    Button(action: {
                        session.setAlert(.auth, "test", "Auth Error Alert", nil)
                    }) {
                        Text(LocalizedStringKey("pref.debugmenu.alerts.auth"))
                            .textCase(.uppercase)
                    }
                    
                    Button(action: {
                        session.setAlert(.api, "test", "API Error Alert", nil)
                    }) {
                        Text(LocalizedStringKey("pref.debugmenu.alerts.api"))
                            .textCase(.uppercase)
                    }
                    
                    Button(action: {
                        session.setAlert(.playback, "test", "Playback Error Alert", nil)
                    }) {
                        Text(LocalizedStringKey("pref.debugmenu.alerts.playback"))
                            .textCase(.uppercase)
                    }
                }
                
                Section(header: Label("pref.debugmenu.analytics.detailedReport", systemImage: "exclamationmark.bubble")) {
                    Button(action: {
                        self.showsDetailedReportPrompt = true
                    }) {
                        Text(LocalizedStringKey("pref.debugmenu.analytics.sendDetailedReport"))
                            .textCase(.uppercase)
                    }
                }
            }
            
            .fullScreenCover(isPresented: $showsDetailedReportPrompt, onDismiss: {
                self.showsDetailedReportPrompt = false
            }, content: {
                DetailedReportPrompt(session: session)
            })
        }
    }
    
    struct DebugMenu_Previews: PreviewProvider {
        static var previews: some View {
            DebugMenu()
        }
    }
    
}

import CoreImage.CIFilterBuiltins

struct DetailedReportPrompt: View {
    @Environment(\.presentationMode) var presentationMode
    
    let session: SessionStore
    
    func generateReport()  {
        guard let jellyfin = session.jellyfin else {
            return
        }
        
        report =  [
            // Preferences
            "betaflags": session.preferences.betaflags.map(\.rawValue).debugDescription,
            "collectionGrouping": session.preferences.collectionGrouping.rawValue,
            "isDebugEnabled": session.preferences.isDebugEnabled.description,
            "posterType": session.preferences.posterType.rawValue,
            "tabs": session.preferences.tabs.map(\.rawValue).debugDescription,
            "showsTitles": session.preferences.showsTitles.description,
            "app-version": session.preferences.version.description,
            "jellyfin-path": (jellyfin.server.path != nil).description,
            "jellyfin-https": jellyfin.server.https.description,
            "jellyfin-port": jellyfin.server.port.description
        ]
        
        self.report = report
    }
    
    @State var report: [String: String] = [:]
    @State var showQrCode: Bool = false
    
    func generateQRCode() -> UIImage {
//        let string = "ATMSG:TO:\njohn@example.com;\nSUB:\nMy comments on your story;\nBODY:\nI just finished reading your story on QR codes.\n[Insert feedback / comments here]\nThanks [Your Name];;"
        let string = "mailto:mail@abjc.tech?subject=[REPORT] [\(session.analytics.id)]&body=[Insert feedback / comments here]"
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        ZStack {
            Blur(.extraDark)
                .edgesIgnoringSafeArea(.all)
            if !showQrCode {
                VStack {
                    Text(LocalizedStringKey("pref.debugmenu.analytics.detailedReport"))
                        .font(.title)
                    ScrollView(.vertical, showsIndicators: true) {
                        Button(action: {}) {
                            HStack {
                                Text(LocalizedStringKey("installation-id"))
                                Spacer()
                                Text(session.analytics.id.uuidString)
                            }
                        }.padding(.horizontal)
                        ForEach(report.keys.sorted(by: { $0 < $1}), id:\.self) { key in
                            Button(action: {}) {
                                HStack {
                                    Text(key)
                                    Spacer()
                                    Text(report[key] ?? "ERROR")
                                }
                            }
                        }.padding(.horizontal)
                    }
                    .padding(.bottom)
                    HStack {
                        Button(action: {
                            session.analytics.log(.detailedReport(report), in: .none)
                            self.showQrCode = true
                        }) {
                            Text(LocalizedStringKey("buttons.submit"))
                                .padding()
                        }.buttonStyle(.card)
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(LocalizedStringKey("buttons.cancel"))
                                .padding()
                        }.buttonStyle(.card)
                    }
                }
            } else {
                VStack {
                    Text(LocalizedStringKey("pref.debugmenu.analytics.detailedReport"))
                        .font(.title)
                    Spacer()
                    Text(LocalizedStringKey("pref.debugmenu.analytics.detailedReport.qrcodedescription"))
                    Image(uiImage: self.generateQRCode())
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 512, height: 512)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15, antialiased: true)
                    
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(LocalizedStringKey("buttons.ok"))
                            .padding()
                    }.buttonStyle(.card)
                }
            }
            
//            QRCode
            
        }
        .onAppear(perform: generateReport)
    }
}
