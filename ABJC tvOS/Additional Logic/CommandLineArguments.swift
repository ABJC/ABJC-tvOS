/*
 ABJC - tvOS
 CommandLineArguments.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Foundation

class CommandLineArguments {
    static var arguments: [String] = CommandLine.arguments

    static func shouldAuthenticate(_ withUser: (String) -> Void) {
        if !CommandLine.arguments.contains("authenticate") {
            return
        } else if let user = getValue(for: "user") {
            withUser(user)
        } else {
            fatalError("authenticate but no user provided")
        }
    }

    static var isDebugEnabled: Bool {
        arguments.contains("enable-debug")
    }

    static var shouldReset: Bool {
        arguments.contains("reset-stores")
    }

    static var isRunningTests: Bool {
        arguments.contains("enable-testing")
    }

    static func getValue(for key: String) -> String? {
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
