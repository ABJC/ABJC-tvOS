/*
 ABJC - tvOS
 AlertObject.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
 */

import SwiftUI

class AlertObject: Identifiable {
    public let id: String
    public let _title: LocalizedStringKey
    public let _message: LocalizedStringKey
    public let _primaryBtn: Alert.Button?
    public let _secondaryBtn: Alert.Button?

    var title: Text {
        Text(_title)
    }

    var message: Text {
        Text(_message)
    }

    var primaryBtn: Alert.Button {
        _primaryBtn!
    }

    var secondaryBtn: Alert.Button {
        _secondaryBtn!
    }

    var hasTwoButtons: Bool {
        _secondaryBtn != nil
    }

    init(id: String? = nil, title: LocalizedStringKey, message: LocalizedStringKey, primaryBtn: Alert.Button, secondaryBtn: Alert.Button?) {
        self.id = id ?? UUID().uuidString
        _title = title
        _message = message
        _primaryBtn = primaryBtn
        _secondaryBtn = secondaryBtn
    }

    init(id: String? = nil, title: LocalizedStringKey, message: LocalizedStringKey, dismissBtn: Alert.Button?) {
        self.id = id ?? UUID().uuidString
        _title = title
        _message = message
        _primaryBtn = dismissBtn
        _secondaryBtn = nil
    }

    convenience init(_ alert: Alerts) {
        self.init(
            id: alert.rawValue,
            title: alert.title,
            message: alert.message,
            primaryBtn: alert.primaryBtn,
            secondaryBtn: alert.secondaryBtn
        )
    }
}
