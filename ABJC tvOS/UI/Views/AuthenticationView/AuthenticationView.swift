/*
 ABJC - tvOS
 AuthenticationView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 08.10.21
 */

import SwiftUI

struct AuthenticationView: View {
    @Namespace var namespace

    @StateObject var store: AuthenticationViewDelegate = .init()

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                // ABJC Logo
                VStack {
                    Image("logo_square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.75)
                }
                .frame(width: geometry.size.width * 4 / 10)

                VStack(alignment: .center) {
                    contentViewHeader.accessibilityIdentifier(store.viewState.rawValue)
                    contentView
                }
                .frame(maxHeight: .infinity)
                .frame(width: geometry.size.width * 6 / 10, height: geometry.size.height)
            }
        }
        .abjcAlert($store.alert)
        .background(BackgroundViews.gradient)
    }

    @ViewBuilder var contentView: some View {
        switch store.viewState {
            case .initial: initView
            case .serverSelection: serverSelectionView
            case .serverManual: serverManualView
            case .userSelection: userSelectionView
            case .userManual: userManualView
            case .persistence: persistenceSelectionView
        }
    }

    @ViewBuilder var contentViewHeader: some View {
        HStack(spacing: 5) {
            Text(store.viewState.localized)
                .font(.title2).bold()

            ProgressView()
                .frame(width: 200)
                .hidden(!store.isLoading)
        }
    }

    var initView: some View {
        ProgressView()
            .onAppear {
                store.checkForPersistence()
            }
    }

    /// View for selecting discovered Servers
    var serverSelectionView: some View {
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
                    store.viewState = .serverManual
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
    }

    /// View for manually entering Server-info
    var serverManualView: some View {
        VStack(spacing: 10) {
            Spacer()
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
            Spacer()
        }
    }

    /// View for selecting a public user
    var userSelectionView: some View {
        VStack(spacing: 10) {
            ScrollView {
                // List of public users

                ForEach(store.publicUsers, id: \.id) { user in
                    Button {
                        store.username = user.name!
                        if !(user.hasPassword ?? true) {
                            store.authenticate(username: user.name ?? "")
                        } else {
                            store.viewState = .userManual
                        }
                    } label: {
                        HStack {
                            UserAvatarView(user: user)
                                .frame(width: 60, height: 60, alignment: .center)
                                .overlay(
                                    Image(systemName: user.hasPassword ?? true ? "lock" : "lock.open")
                                        .foregroundColor(.secondary)
                                        .padding(2),
                                    alignment: .bottomLeading
                                )
                                .padding()
                                .frame(width: 60, height: 60, alignment: .center)

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
                }

                // Manual User Entry
                Button {
                    store.viewState = .userManual
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
                .padding()
            }
        }
    }

    /// View for manually entering user-info
    var userManualView: some View {
        VStack {
            Group {
                TextField(LocalizedStringKey("username"), text: $store.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.username)
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

    var persistenceSelectionView: some View {
        VStack(spacing: 10) {
            ScrollView {
                // List of persisted users
                ForEach(store.persistedUsers, id: \.id) { user in
                    Button {
                        store.authenticate(user)
                    } label: {
                        HStack {
                            #warning("Implement UserAvatarView for Persisted User")
//                            UserAvatarView(user: user)
//                                .frame(width: 60, height: 60, alignment: .center)
//                                .overlay(
//                                    Image(systemName: user.hasPassword ?? true ? "lock" : "lock.open")
//                                        .foregroundColor(.secondary)
//                                        .padding(2),
//                                    alignment: .bottomLeading
//                                )
//                                .padding()
//                                .frame(width: 60, height: 60, alignment: .center)

                            VStack(alignment: .leading, spacing: 10) {
                                Text(user.name ?? "Missing Username")
                                    .bold()
                                    .font(.headline)
                                    .textCase(.uppercase)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(user.serverName ?? "No Server Name")
                                    Text(user.serverURI ?? "No Server URI")
                                }
                                .font(.callout)
                                .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                    }
                    .prefersDefaultFocus(store.persistedUsers.firstIndex(of: user) == store.persistedUsers.startIndex, in: namespace)
                    .accessibilityIdentifier("userBtn-\(user.name ?? "noname")")
                    .padding()
                }

                // Manual User Entry
                Button {
                    store.viewState = .serverSelection
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
                            Text("New User")
                                .bold()
                                .font(.headline)
                                .textCase(.uppercase)
                            Text("Add another user")
                                .font(.system(.callout, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
                .accessibilityIdentifier("newUserBtn")
                .padding()
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
