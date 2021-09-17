//
//  AuthenticationUITests.swift
//  AuthenticationUITests
//
//  Created by Noah Kamara on 13.09.21.
//

import XCTest

class AuthenticationUITests: XCTestCase {
    let app = XCUIApplication()
    let constants = UITestConstants(.init(for: AuthenticationUITests.self))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    /// Test UI Elements in ManualServerEntry
    func testManualServerEntryUI() {
        // Wait for welcome screen
        UITestHelpers.findAndPressButton(app.buttons["enterServerManuallyBtn"], .down)

        // Check for TextFields
        let hostField = app.textFields["hostField"]
        let portField = app.textFields["portField"]
        let pathField = app.textFields["pathField"]
        let sslSwitch = app.switches["sslSwitch"]
        let continueButton = app.buttons["continueBtn"]

        // Take Screenshot
        add(UITestHelpers.takeScreenshot("ManualServerEntryUI"))

        // Check if all UI Elements exist
        XCTAssert(hostField.waitForExistence(timeout: 5.0), "Host Field exists")
        XCTAssert(portField.waitForExistence(timeout: 5.0), "Port Field exists")
        XCTAssert(pathField.waitForExistence(timeout: 5.0), "Path Field exists")
        XCTAssert(sslSwitch.waitForExistence(timeout: 5.0), "SSL Switch exists")
        XCTAssert(continueButton.waitForExistence(timeout: 5.0), "Continue BTN exists")

        // Check if value entering is possible
        UITestHelpers.withOpenTextField(hostField, .down) {
            hostField.clearAndEnterText(text: "HOST")
        }
        XCTAssert(hostField.value as! String == "HOST", "Host Field is settable")

        UITestHelpers.withOpenTextField(portField, .down) {
            portField.clearAndEnterText(text: "PORT")
        }
        XCTAssert(portField.value as! String == "PORT", "Port Field is settable")

        UITestHelpers.withOpenTextField(pathField, .down) {
            pathField.clearAndEnterText(text: "PATH")
        }
        XCTAssert(pathField.value as! String == "PATH", "Path Field is settable")
    }

    /// Test Manually Connecting to Server
    func testManualServerEntry() {
        // Navigate to Manual Server Entry Screen
        UITestHelpers.findAndPressButton(app.buttons["enterServerManuallyBtn"], .down)

        // manually enter server information
        UITestHelpers.authConnectToServer(
            app,
            host: constants.serverHost,
            port: constants.serverPort,
            path: constants.serverPath
        )
    }

    /// Test Manually Connecting to Server
    func testDiscoveredServerUI() {
        XCTExpectFailure("Server currently not exposed over Multicast")

        // Navigate to Manual Server Entry Screen
        let enterServerManuallyBtn = app.buttons["enterServerManuallyBtn"]
        UITestHelpers.findAndPressButton(enterServerManuallyBtn, .down)

        // Take Screenshot
        add(UITestHelpers.takeScreenshot("DiscoveredServerUI"))

        // test whether server has buttons
        XCTAssert(app.buttons.matching(identifier: "serverBtn").firstMatch.waitForExistence(timeout: 30.0))
    }

    /// Test UI Elements in ManualUserEntry
    func testManualUserEntryUI() {
        // Navigate to Manual Server Entry Screen
        let enterServerManuallyBtn = app.buttons["enterServerManuallyBtn"]
        UITestHelpers.findAndPressButton(enterServerManuallyBtn, .down)

        // manually enter server information
        UITestHelpers.authConnectToServer(
            app,
            host: constants.serverHost,
            port: constants.serverPort,
            path: constants.serverPath
        )

        // Navigate to Manual User Entry Screen
        UITestHelpers.findAndPressButton(app.buttons["manualUserBtn"], .down)

        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let continueButton = app.buttons["continueBtn"]

        // Take Screenshot
        add(UITestHelpers.takeScreenshot("UserEntryUI"))

        // Verify that elements exist
        XCTAssert(usernameField.waitForExistence(timeout: 5.0), "Username Field exists")
        XCTAssert(passwordField.waitForExistence(timeout: 5.0), "Password Field exists")
        XCTAssert(continueButton.waitForExistence(timeout: 5.0), "Continue BTN exists")

        // Check if value entering is possible
        UITestHelpers.withOpenTextField(usernameField, .down) {
            usernameField.clearAndEnterText(text: "USERNAME")
        }
        XCTAssert(usernameField.value as! String == "USERNAME", "Username Field is settable")

        UITestHelpers.withOpenTextField(passwordField, .down) {
            passwordField.clearAndEnterText(text: "PASSWORD")
        }
        XCTAssert(passwordField.value as! String == "••••••••", "Password Field is settable")
    }

    /// Test Manually Authenticating Users
    func testManualUserEntry() {
        func test(username: String, password: String) -> XCUIApplication {
            let app = XCUIApplication()
            app.launch()

            // Navigate to Manual Server Entry Screen
            let enterServerManuallyBtn = app.buttons["enterServerManuallyBtn"]
            UITestHelpers.findAndPressButton(enterServerManuallyBtn, .down)

            // manually enter server information
            UITestHelpers.authConnectToServer(
                app,
                host: constants.serverHost,
                port: constants.serverPort,
                path: constants.serverPath
            )

            // Navigate to Manual User Entry Screen
            UITestHelpers.findAndPressButton(app.buttons["manualUserBtn"], .down)

            // manually enter user information
            UITestHelpers.authAuthenticateUser(
                app,
                username: username,
                password: password
            )

            // Take Screenshot
            add(UITestHelpers.takeScreenshot("ManualUserEntry-\(username)-\(password)"))

            return app
        }

        // Test with correct credentials
        let resultCorrect = test(username: constants.manualUserName, password: constants.manualUserPass)
        XCTAssert(
            resultCorrect.otherElements["main-nav"].waitForExistence(timeout: 15.0),
            "Authenticated Successfully"
        )

        // Test with wrong username
        let resultWrongUser = test(username: "wrongUser", password: constants.manualUserPass)
        XCTAssert(
            resultWrongUser.alerts["Authentication failed"].waitForExistence(timeout: 30.0),
            "Alert 'Authentication Failure' displayed"
        )

        // Test with wrong password
        let resultWrongPass = test(username: constants.manualUserName, password: "wrongPassword")
        XCTAssert(
            resultWrongPass.alerts["Authentication failed"].waitForExistence(timeout: 30.0),
            "Alert 'Authentication Failure' displayed"
        )

        // Test with wrong username and password
        let resultWrongAll = test(username: "wrongUser", password: "wrongPassword")
        XCTAssert(
            resultWrongAll.alerts["Authentication failed"].waitForExistence(timeout: 30.0),
            "Alert 'Authentication Failure' displayed"
        )
    }

    /// Test Authenticating Public Users
    func testPublicUserSelection() {
        func test(_ completion: (XCUIApplication) -> Void) {
            let app = XCUIApplication()
            app.launch()

            // Navigate to Manual Server Entry Screen
            let enterServerManuallyBtn = app.buttons["enterServerManuallyBtn"]
            UITestHelpers.findAndPressButton(enterServerManuallyBtn, .down)

            // manually enter server information
            UITestHelpers.authConnectToServer(
                app,
                host: constants.serverHost,
                port: constants.serverPort,
                path: constants.serverPath
            )

            XCTAssert(app.buttons["manualUserBtn"].waitForExistence(timeout: 15.0))
            completion(app)
            app.terminate()
        }

        // Test with password success
        let testWithPasswordSuccess = expectation(description: "Test with password success")
        test { app in
            let username = constants.passUserName
            let password = constants.passUserPass

            let userBtn = app.buttons["userBtn-" + username]
            XCTAssert(userBtn.waitForExistence(timeout: 15.0))
            UITestHelpers.findAndPressButton(userBtn, .up)

            let usernameField = app.textFields["usernameField"]
            let passwordField = app.secureTextFields["passwordField"]
            let continueButton = app.buttons["continueBtn"]

            // Test whether username field is correctl initialized
            XCTAssert(usernameField.waitForExistence(timeout: 30.0))
            XCTAssert(usernameField.value as! String == username)

            // Fill in password
            XCTAssert(passwordField.waitForExistence(timeout: 30.0))
            UITestHelpers.withOpenTextField(passwordField, .down) {
                passwordField.clearAndEnterText(text: password)
            }

            // Take Screenshot
            add(UITestHelpers.takeScreenshot("PublicUserSelection-with_password_success"))

            UITestHelpers.findAndPressButton(continueButton, .down)

            XCTAssertFalse(
                app.alerts["Authentication failed"].waitForExistence(timeout: 5.0),
                "No Alert 'Authentication Failure' displayed"
            )
            XCTAssert(
                app.tabBars.count == 1,
                "Authenticated Successfully"
            )
            testWithPasswordSuccess.fulfill()
        }

        // Test with password failure
        let testWithPasswordFail = expectation(description: "Test with password failure")
        test { app in
            let username = constants.passUserName
            let password = "wrongPassword"

            let userBtn = app.buttons["userBtn-" + username]
            XCTAssert(userBtn.waitForExistence(timeout: 15.0))
            UITestHelpers.findAndPressButton(userBtn, .up)

            let usernameField = app.textFields["usernameField"]
            let passwordField = app.secureTextFields["passwordField"]
            let continueButton = app.buttons["continueBtn"]

            // Test whether username field is correctl initialized
            XCTAssert(usernameField.waitForExistence(timeout: 30.0))
            XCTAssert(usernameField.value as! String == username)

            // Fill in password
            XCTAssert(passwordField.waitForExistence(timeout: 30.0))
            UITestHelpers.withOpenTextField(passwordField, .down) {
                passwordField.clearAndEnterText(text: password)
            }

            UITestHelpers.findAndPressButton(continueButton, .down)

            XCTAssert(
                app.alerts["Authentication failed"].waitForExistence(timeout: 30.0),
                "Alert 'Authentication Failure' displayed"
            )
            testWithPasswordFail.fulfill()
        }

        // Test without password
        let testWithoutPassword = expectation(description: "Test without password")
        test { app in
            let username = constants.nopassUserName

            let userBtn = app.buttons["userBtn-" + username]
            XCTAssert(userBtn.waitForExistence(timeout: 15.0))
            UITestHelpers.findAndPressButton(userBtn, .up)

            XCTAssertFalse(
                app.alerts["Authentication failed"].waitForExistence(timeout: 5.0),
                "No Alert 'Authentication Failure' displayed"
            )
            XCTAssert(
                app.tabBars.count == 1,
                "Authenticated Successfully"
            )
            testWithoutPassword.fulfill()
        }

        wait(for: [testWithPasswordSuccess, testWithPasswordFail, testWithoutPassword], timeout: 15.0)
    }
}
