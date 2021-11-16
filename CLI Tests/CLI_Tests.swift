/*
 ABJC - tvOS
 CLI_Tests.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10.10.21
 */

@testable import ABJC__tvOS_
import XCTest

class CLI_Tests: XCTestCase {
    func mockArgs(_ args: [String: String?] = [:]) -> CommandLineArguments {
        CommandLineArguments(args.reduce([]) { partialResult, item in
            guard var partialResult = partialResult else {
                if let value = item.value {
                    return ["\(item.key)=\(value)"]
                } else {
                    return [item.key]
                }
            }
            if let value = item.value {
                partialResult.append("\(item.key)=\(value)")
            } else {
                partialResult.append(item.key)
            }
            return partialResult
        })
    }

    /// Test whether the 'authenticate' and 'user={user}' parameter is parsed correctly
    func testShouldAuthenticate() {
        let testuser = "testuser"
        var args = mockArgs([
            "authenticate": nil,
            "user": "\(testuser)"
        ])

        let expect = expectation(description: "Wait for Parsing")
        args.shouldAuthenticate { user in
            XCTAssert(true, "ShouldAuthenticate was parsed correctly")
            XCTAssert(user == testuser, "User was parsed correctly")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)

        args = mockArgs()
        args.shouldAuthenticate { _ in
            XCTFail("ShouldAuthenticate was parsed correctly")
        }
    }

    /// Test whether the 'debug' parameter is parsed correctly
    func testIsDebugEnabled() {
        let args = mockArgs([
            "enable-debug": nil
        ])

        XCTAssert(args.isDebugEnabled, "Debug was parsed correctly")
    }

    /// Test whether the 'debug' parameter is parsed correctly
    func testShouldReset() {
        let args = mockArgs([
            "reset-stores": nil
        ])

        XCTAssert(args.shouldReset, "Debug was parsed correctly")

        let args2 = mockArgs()
        XCTAssert(!args2.shouldReset, "Debug was parsed correctly")
    }

    /// Test whether the 'constants={jsonString}' parameters are parsed correctly
    func testConstants() throws {
        var args = mockArgs([
            "constants": "{\"users\":{\"user_pass\":{\"username\":\"username\",\"password\":\"password\"},\"user_nopass\":{\"username\":\"username\",\"password\":\"\"},\"user_hidden\":{\"username\":\"username\",\"password\":\"password\"}},\"server\":{\"path\":\"path\",\"host\":\"localhost\",\"scheme\":\"http\",\"port\":\"8096\"},\"analytics\":{\"uri\":\"http:\\/\\/localhost:8080\\/analytics\",\"key\":\"\"}}"
        ])

        let constants = Constants(
            users: [
                "user_hidden": .init(password: "password", username: "username"),
                "user_pass": .init(password: "password", username: "username"),
                "user_nopass": .init(password: "", username: "username")
            ],
            server: .init(scheme: "http", host: "localhost", port: "8096", path: "path"),
            analytics: .init(uri: "http://localhost:8080/analytics", key: "")
        )

        XCTAssert(
            args.constants != nil,
            "Constants: result is not nil"
        )

        guard let parseResult = args.constants else {
            XCTFail("result is NIL")
            return
        }

        XCTAssert(
            parseResult.serverURI == constants.serverURI,
            "Constants: 'constants.server' parsed correctly"
        )

        for (key, value) in constants.users {
            XCTAssert(
                parseResult.users.keys.contains(key),
                "Constants: user '\(key)' is in parseResult"
            )
            XCTAssert(
                parseResult.users[key]?.username == value.username,
                "Constants: user '\(key)' has correct username"
            )
            XCTAssert(
                parseResult.users[key]?.password == value.password,
                "Constants: user '\(key)' has correct password"
            )
        }

        args = mockArgs()
        XCTAssertNil(args.constants)
    }
}
