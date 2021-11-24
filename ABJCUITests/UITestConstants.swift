/*
 ABJC - tvOS
 UITestConstants.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import Foundation

class UITestConstants {
    let constants: Constants

    init(_ bundle: Bundle) {
        constants = .with(bundle: bundle)!
    }

    var serverHost: String { constants.server.host }
    var serverPort: String { constants.server.port }
    var serverPath: String { constants.server.path }
    var serverSsl: Bool { constants.server.scheme == "https" }

    var manualUser: Constants.Credentials { constants.users["user_hidden"]! }
    var manualUserName: String { manualUser.username }
    var manualUserPass: String { manualUser.password ?? "" }

    var nopassUser: Constants.Credentials { constants.users["user_nopass"]! }
    var nopassUserName: String { nopassUser.username }
    var nopassUserPass: String { nopassUser.password ?? "" }

    var passUser: Constants.Credentials { constants.users["user_pass"]! }
    var passUserName: String { passUser.username }
    var passUserPass: String { passUser.password ?? "" }
}
