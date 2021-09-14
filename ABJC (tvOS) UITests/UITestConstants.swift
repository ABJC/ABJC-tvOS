//
//  UITestConstants.swift
//  UITestConstants
//
//  Created by Noah Kamara on 13.09.21.
//

import Foundation

class UITestConstants {
    static let constants: Constants = .with(bundle: .init(for: ABJC__tvOS__UITests.self))!

    static let serverHost: String = constants.server.host
    static let serverPort: String = constants.server.port
    static let serverPath: String = constants.server.path
    static let serverSsl: Bool = constants.server.scheme == "https"

    static var manualUser: Constants.Credentials { constants.users["user_hidden"]! }
    static var manualUserName: String { manualUser.username }
    static var manualUserPass: String { manualUser.password ?? "" }

    static var nopassUser: Constants.Credentials { constants.users["user_nopass"]! }
    static var nopassUserName: String { nopassUser.username }
    static var nopassUserPass: String { nopassUser.password ?? "" }

    static var passUser: Constants.Credentials { constants.users["user_pass"]! }
    static var passUserName: String { passUser.username }
    static var passUserPass: String { passUser.password ?? "" }
}
