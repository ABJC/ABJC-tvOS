/*
 ABJC - tvOS
 CommandLineArguments.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10.10.21
 */

import Foundation

class CommandLineArguments {
    var arguments: [String]

    init(_ arguments: [String]? = nil) {
        self.arguments = arguments ?? CommandLine.arguments
    }

    func shouldAuthenticate(_ withUser: (String) -> Void) {
        if !arguments.contains("authenticate") {
            return
        } else if let user = getValue(for: "user") {
            withUser(user)
        } else {
            fatalError("authenticate but no user provided")
        }
    }

    var constants: Constants? {
        do {
            guard let jsonString = getValue(for: "constants"),
                  let jsonData = jsonString.data(using: .utf8) else {
                return nil
            }
            let constants = Constants(
                users: [
                    "user_hidden": .init(password: "password", username: "user_hidden"),
                    "user_pass": .init(password: "password", username: "user_pass"),
                    "user_nopass": .init(password: "", username: "user_nopass")
                ],
                server: .init(scheme: "http", host: "localhost", port: "8096", path: "path"),
                analytics: .init(uri: "http://localhost:8080/analytics", key: "")
            )
            let jsonEncoder = JSONEncoder()
            let json = String(data: try jsonEncoder.encode(constants), encoding: .utf8)
            print(json)

            // Decode
            let jsonDecoder = JSONDecoder()
            let parsedConst = try jsonDecoder.decode(Constants.self, from: jsonData)

            return parsedConst
        } catch {
            print(error)
            return nil
        }
    }

    var isDebugEnabled: Bool {
        arguments.contains("enable-debug")
    }

    var shouldReset: Bool {
        arguments.contains("reset-stores")
    }

    var isRunningTests: Bool {
        arguments.contains("enable-testing")
    }

    func getValue(for key: String) -> String? {
        let regex = "\(key)=.*"
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = arguments.map { arg -> String? in
                let res = regex.matches(in: arg, range: NSRange(arg.startIndex..., in: arg))

                if let res = res.first {
                    return String(arg[Range(res.range, in: arg)!].replacingOccurrences(of: "\(key)=", with: ""))
                }
                return nil
            }.compactMap { string in
                string
            }

            return results.last
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}
