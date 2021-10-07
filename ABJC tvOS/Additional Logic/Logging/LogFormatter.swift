/*
 ABJC - tvOS
 LogFormatter.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Foundation
import Puppy

enum LogType: String {
    case console
    case file
    case debug
}

class LogFormatter: LogFormattable {
    private let logType: LogType

    init(_ logType: LogType) {
        self.logType = logType
    }

    func formatMessage(
        _ level: LogLevel,
        message: String,
        tag: String,
        function: String,
        file: String,
        line: UInt,
        swiftLogInfo: [String: String],
        label: String,
        date: Date,
        threadID: UInt64
    ) -> String {
        switch logType {
            case .console:
                return consoleFormat(
                    level,
                    message: message,
                    tag: tag,
                    function: function,
                    file: file,
                    line: line,
                    swiftLogInfo: swiftLogInfo,
                    label: label,
                    date: date,
                    threadID: threadID
                )
            case .file:
                return fileFormat(
                    level,
                    message: message,
                    tag: tag,
                    function: function,
                    file: file,
                    line: line,
                    swiftLogInfo: swiftLogInfo,
                    label: label,
                    date: date,
                    threadID: threadID
                )
            case .debug:
                return debugFormat(
                    level,
                    message: message,
                    tag: tag,
                    function: function,
                    file: file,
                    line: line,
                    swiftLogInfo: swiftLogInfo,
                    label: label,
                    date: date,
                    threadID: threadID
                )
        }
    }

    func consoleFormat(
        _ level: LogLevel,
        message: String,
        tag _: String,
        function: String,
        file: String,
        line: UInt,
        swiftLogInfo _: [String: String],
        label _: String,
        date: Date,
        threadID _: UInt64
    ) -> String {
        let date = dateFormatter(date)
        let file = shortFileName(file).replacingOccurrences(of: ".swift", with: "")
        return "\(date) [\(level)] (\(file)#\(line)) \(function) - \(message)"
    }

    func fileFormat(
        _ level: LogLevel,
        message: String,
        tag _: String,
        function: String,
        file: String,
        line: UInt,
        swiftLogInfo _: [String: String],
        label _: String,
        date _: Date,
        threadID: UInt64
    ) -> String {
        let file = shortFileName(file).replacingOccurrences(of: ".swift", with: "")
        return "\(level.emoji) (\(threadID)) (\(file)#\(line)) \(function) - \(message)"
    }

    func debugFormat(
        _ level: LogLevel,
        message: String,
        tag _: String,
        function: String,
        file: String,
        line: UInt,
        swiftLogInfo _: [String: String],
        label _: String,
        date: Date,
        threadID: UInt64
    ) -> String {
        let date = dateFormatter(date)
        let file = shortFileName(file).replacingOccurrences(of: ".swift", with: "")
        return "\(level.emoji) \(date) (\(threadID)) [\(level)] (\(file)#\(line)) \(function): \(message)"
    }
}
