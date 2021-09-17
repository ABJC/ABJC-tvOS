//
//  AuthenticationView.swift
//  AuthenticationView
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI

struct AuthenticationView: View {
    @Namespace
    var namespace
    // Store for View
    @StateObject
    var store: AuthenticationViewDelegate = .init()

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                // ABJC Logo
                VStack {
                    Image("logo_stacked")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.75)
                }
                .frame(width: geometry.size.width * 4 / 10)

                // View
                Group {
                    if store.isConnected {
                        userSelectionView.frame(width: geometry.size.width * 6 / 10, height: geometry.size.height)
                    } else {
                        serverSelectionView.frame(width: geometry.size.width * 6 / 10, height: geometry.size.height)
                    }
                }
                .frame(width: geometry.size.width * 6 / 10, height: geometry.size.height)
            }
        }
        .abjcAlert($store.alert)
        .background(BackgroundViews.gradient)
    }

    var serverSelectionView: some View {
        VStack(alignment: .center) {
            HStack(spacing: 5) {
                Text("Server Selection")
                    .font(.title2).bold()

                ProgressView()
                    .frame(width: 200)
                    .hidden(!store.isDiscoveringServers)
            }

            Group {
                if !store.willEnterServerManually {
                    VStack(spacing: 10) {
                        ScrollView {
                            // List of discovered Servers
                            ForEach(store.discoveredServers) { server in
                                Button {
                                    store.setServer(to: server.url.absoluteString)
                                } label: {
                                    HStack {
                                        Image(systemName: "server.rack")
                                            .font(.system(.largeTitle))
                                        VStack(alignment: .leading) {
                                            Text(server.name)
                                                .bold()
                                                .font(.headline)
                                                .textCase(.uppercase)
                                            Text(server.url.absoluteString)
                                                .font(.system(.callout, design: .monospaced))
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                    }
                                }
                                .accessibilityIdentifier("serverBtn")
                            }
                            .padding()

                            // Manual Server entry
                            Button {
                                store.willEnterServerManually = true
                            } label: {
                                HStack {
                                    Image(systemName: "server.rack")
                                        .font(.system(.largeTitle))
                                    VStack(alignment: .leading) {
                                        Text("Enter Manually")
                                            .bold()
                                            .font(.headline)
                                            .textCase(.uppercase)
                                        Text("Enter host, port, etc. manually")
                                            .font(.system(.callout, design: .monospaced))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                            }
                            .accessibilityIdentifier("enterServerManuallyBtn")
                            .padding()
                        }
                    }
                } else {
                    // Manually enter Server info
                    manualServerEntryView
                }
            }
        }.frame(maxHeight: .infinity)
    }

    /// View for entering server manually
    var manualServerEntryView: some View {
        VStack {
            Group {
                TextField(LocalizedStringKey("Host"), text: $store.manualHost)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.URL)
                    .prefersDefaultFocus(store.manualHost.isEmpty, in: namespace)
                    .accessibilityIdentifier("hostField")

                TextField(LocalizedStringKey("Port"), text: $store.manualPort)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .prefersDefaultFocus(!store.manualHost.isEmpty && store.manualPort.isEmpty, in: namespace)
                    .accessibilityIdentifier("portField")

                TextField("/jellyfin", text: $store.manualPath)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .prefersDefaultFocus(!store.manualHost.isEmpty && !store.manualPort.isEmpty && store.manualPath.isEmpty, in: namespace)
                    .accessibilityIdentifier("pathField")

                Toggle("Use SSL (HTTPS)", isOn: $store.manualHttps)
                    .accessibilityIdentifier("sslSwitch")

                Button {
                    store.setServerManual()
                } label: {
                    if store.isLoading {
                        ProgressView()
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Text("Continue").textCase(.uppercase)
                    }
                }
                .accessibilityIdentifier("continueBtn")
                .prefersDefaultFocus(!store.manualHost.isEmpty && !store.manualPort.isEmpty && !store.manualPath.isEmpty, in: namespace)
            }
        }
    }

    var userSelectionView: some View {
        VStack {
            Text("Who's Watching?")
                .font(.title)
                .padding(.bottom, 30)

            Group {
                if !store.willEnterUserManually {
                    VStack(spacing: 10) {
                        ScrollView {
                            // List of public users

                            ForEach(store.publicUsers, id: \.id) { user in
                                Button {
                                    store.username = user.name!
                                    if !(user.hasPassword ?? true) {
                                        store.authenticate(username: user.name ?? "")
                                    } else {
                                        store.willEnterUserManually = true
                                    }

                                } label: {
                                    HStack {
                                        UserAvatarView(user: user)
                                            .frame(width: 60, height: 60, alignment: .center)
                                            .overlay(Image(systemName: user.hasPassword ?? true ? "lock" : "lock.open")
                                                .padding(2),
                                                alignment: .bottomLeading)
                                            .padding()

                                        VStack(alignment: .leading) {
                                            Text(user.name ?? "Missing Username")
                                                .bold()
                                                .font(.headline)
                                                .textCase(.uppercase)
                                            Text("user.")
                                                .font(.system(.callout, design: .monospaced))
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.forward")
                                    }
                                }
                                .prefersDefaultFocus(store.publicUsers.firstIndex(of: user) == store.publicUsers.startIndex, in: namespace)
                                .accessibilityIdentifier("userBtn-\(user.name ?? "noname")")
                                .buttonStyle(CardButtonStyle())
                            }.padding()
                                .background(Color.pink)

                            // Manual User Entry
                            Button {
                                store.willEnterUserManually = true
                            } label: {
                                HStack {
                                    ZStack {
                                        Circle().fill(.thickMaterial)
                                        Image(systemName: "person.fill.badge.plus")
                                            .foregroundColor(.accentColor)
                                            .font(.system(.largeTitle))
                                    }
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding()

                                    VStack(alignment: .leading) {
                                        Text("Enter Manually")
                                            .bold()
                                            .font(.headline)
                                            .textCase(.uppercase)
                                        Text("Enter credentials manually")
                                            .font(.system(.callout, design: .monospaced))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                            }
                            .accessibilityIdentifier("manualUserBtn")
                            .buttonStyle(CardButtonStyle())
                            .padding()
                        }
                    }
                } else {
                    userEntryView
                }
            }
            .padding(.top)
        }.background(Color.blue)
    }

    /// View for entering user manually
    var userEntryView: some View {
        VStack {
            Group {
                TextField(LocalizedStringKey("username"), text: $store.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.username)
                    .disabled(!store.willEnterUserManually)
                    .prefersDefaultFocus(store.username.isEmpty, in: namespace)
                    .accessibilityIdentifier("usernameField")

                SecureField(LocalizedStringKey("password"), text: $store.password, prompt: nil)
                    .autocapitalization(.none)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                    .prefersDefaultFocus(!store.username.isEmpty && store.password.isEmpty, in: namespace)
                    .accessibilityIdentifier("passwordField")

                Button {
                    if store.password.isEmpty {
                        store.authenticate(username: store.username)
                    } else {
                        store.authenticate(username: store.username, password: store.password)
                    }

                } label: {
                    if store.isLoading {
                        ProgressView()
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Text("Continue").textCase(.uppercase)
                    }
                }
                .accessibilityIdentifier("continueBtn")
                .prefersDefaultFocus(!store.username.isEmpty && !store.password.isEmpty, in: namespace)
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
