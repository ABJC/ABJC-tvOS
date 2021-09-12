//
//  UserAvatar.swift
//  UserAvatar
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI
import Combine
import JellyfinAPI

class UserAvatarViewDelegate: ViewDelegate {
    private let user: UserDto
    @Published var imageUrl: URL? = nil
    
    init(user: UserDto) {
        self.user = user
    }
    
    func loadImageUrl() {
        guard let userId = user.id else {
            return
        }
        
        ImageAPI.getUserImage(userId: userId, imageType: .profile) { result in
            switch result {
                case .success(let url): self.imageUrl = url
                case .failure(let error): self.handleApiError(error)
            }
        }
    }
}

struct UserAvatarView: View {
    private let store: UserAvatarViewDelegate
    
    init(user: UserDto) {
        self.store = .init(user: user)
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

//struct UserAvatar_Previews: PreviewProvider {
//    static var previews: some View {
//        UserAvatar(user: UserDto.preview)
//    }
//}
