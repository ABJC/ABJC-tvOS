//
//  AlertObject.swift
//  AlertObject
//
//  Created by Noah Kamara on 13.09.21.
//

import SwiftUI

class AlertObject: Identifiable {
    public let id: String
    public let _title: LocalizedStringKey
    public let _message: LocalizedStringKey
    public let _primaryBtn: Alert.Button?
    public let _secondaryBtn: Alert.Button?

    var title: Text {
        return Text(_title)
    }

    var message: Text {
        return Text(_message)
    }

    var primaryBtn: Alert.Button {
        return _primaryBtn!
    }

    var secondaryBtn: Alert.Button {
        return _secondaryBtn!
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
        self.init(id: alert.rawValue, title: alert.title, message: alert.message, primaryBtn: alert.primaryBtn, secondaryBtn: alert.secondaryBtn)
    }
}
