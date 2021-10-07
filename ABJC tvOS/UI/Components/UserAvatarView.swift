/*
 ABJC - tvOS
 UserAvatarView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Combine
import JellyfinAPI
import SwiftUI

class UserAvatarViewDelegate: ViewDelegate {
    private let user: UserDto
    @Published
    var imageUrl: URL?

    init(user: UserDto) {
        self.user = user
    }

    func loadImageUrl() {
        guard let userId = user.id else {
            return
        }

        ImageAPI.getUserImage(userId: userId, imageType: .profile) { result in
            switch result {
                case let .success(url): self.imageUrl = url
                case let .failure(error): self.handleApiError(error)
            }
        }
    }
}

struct UserAvatarView: View {
    private let store: UserAvatarViewDelegate

    init(user: UserDto) {
        store = .init(user: user)
    }

    var body: some View {
        AsyncImg(url: store.imageUrl) { image in
            image
                .renderingMode(.original)
                .resizable()
        } placeholder: {
            ZStack {
                Blur()
                Image(systemName: "person.fill")
                    .imageScale(.large)
            }
        }
        .clipShape(Circle())
        .onAppear(perform: store.loadImageUrl)
    }
}

// struct UserAvatar_Previews: PreviewProvider {
//    static var previews: some View {
//        UserAvatar(user: UserDto.preview)
//    }
// }
