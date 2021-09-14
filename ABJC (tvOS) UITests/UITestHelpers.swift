//
//  UITestHelpers.swift
//  UITestHelpers
//
//  Created by Noah Kamara on 13.09.21.
//

import Foundation
import XCTest

class UITestHelpers {
    static let timeout: TimeInterval = 15.0

    static func findAndPressButton(_ element: XCUIElement, _ button: XCUIRemote.Button) {
        let startDate = Date()
        var waiting = true
        while waiting {
            if element.descendants(matching: .any).firstMatch.hasFocus {
                waiting = false
                XCUIRemote.shared.press(.select)
            } else if Date().timeIntervalSince(startDate) > timeout {
                waiting = false
                XCTAssert(false, "TimeOut Error for expection")
            } else {
                XCUIRemote.shared.press(button)
            }
        }
    }

    static func withOpenTextField(_ element: XCUIElement, _ button: XCUIRemote.Button, _ completion: () -> Void) {
        let startDate = Date()
        var waiting = true
        while waiting {
            if element.hasFocus {
                waiting = false
                XCUIRemote.shared.press(.select)
                completion()
                XCUIRemote.shared.press(.menu)
            } else if Date().timeIntervalSince(startDate) > timeout {
                waiting = false
                XCTAssert(false, "TimeOut Error for expection")
            } else {
                XCUIRemote.shared.press(button)
            }
        }
    }

    static func authConnectToServer(_ app: XCUIApplication, host: String, port _: String, path _: String) {
        // Elements
        let hostField = app.textFields["hostField"]
        let portField = app.textFields["portField"]
        let pathField = app.textFields["pathField"]
//        let sslSwitch = app.switches["sslSwitch"]
        let continueButton = app.buttons["continueBtn"]

        // Wait until field is presented
        XCTAssert(hostField.waitForExistence(timeout: 30.0))

        // Enter Host
        withOpenTextField(hostField, .down) {
            hostField.clearAndEnterText(text: host)
        }
        XCTAssert(hostField.value as? String == host, "Host Field has correct value")

//        // Enter Port
//        withOpenTextField(portField, .down) {
//            portField.clearAndEnterText(text: port)
//        }
//        XCTAssert(portField.value as? String == port, "Port Field has correct value")
//
//        // Enter Path
//        withOpenTextField(pathField, .down) {
//            pathField.clearAndEnterText(text: path)
//        }
//        let path = (path.isEmpty ? pathField.placeholderValue! : path)
//        XCTAssert(pathField.value as? String == path, "Path Field has correct value")

        findAndPressButton(continueButton, .down)
    }

    static func authAuthenticateUser(_ app: XCUIApplication, username: String, password: String) {
        // Elements
        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let continueButton = app.buttons["continueBtn"]

        // Wait until field is presented
        XCTAssert(usernameField.waitForExistence(timeout: 30.0))

        // Enter Username
        withOpenTextField(usernameField, .down) {
            usernameField.clearAndEnterText(text: username)
        }
        XCTAssert(usernameField.value as! String == username)

        // Enter Password
        withOpenTextField(passwordField, .down) {
            passwordField.clearAndEnterText(text: password)
        }
        print(passwordField.value)

        XCTAssert(passwordField.value as! String == String(repeating: "•", count: password.count))

        // Continue
        findAndPressButton(continueButton, .down)
    }
}
