/*
 ABJC - tvOS
 Logger.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import Foundation
import Puppy

class Logger {
    static let shared = Logger()

    let log = Puppy()
    let logLevel: LogLevel

    weak var fileRotationDelegate: LogFileRotationDelegate? { LogFileRotationDelegate() }
    let fileURL: URL

    init(logLevel: LogLevel = .debug) {
        // SetUp LogLevel
        self.logLevel = logLevel

        // SetUp FileURL
        fileURL = URL(fileURLWithPath: "./abjc.log").absoluteURL

        do {
            try setUpFileRotation()
        } catch {
            print("setUpFileRotation", error)
        }

        do {
            try setUpLoggers()
        } catch {
            print("setUpLoggers", error)
        }
    }

    internal func setUpFileRotation() throws {
        let fileRotation = try FileRotationLogger("com.noahkamara.abjc.filerotation", fileURL: fileURL)
        fileRotation.maxFileSize = 10 * 1024 * 1024
        fileRotation.maxArchivedFilesCount = 5
        if let fileRotationDelegate = fileRotationDelegate {
            fileRotation.delegate = fileRotationDelegate
        }

        let log = Puppy()
        log.add(fileRotation)
        log.info("INFO message")
        log.warning("WARNING message")
    }

    internal func setUpLoggers() throws {
        #if DEBUG
            // SetConsoleLogger
            let console = ConsoleLogger("com.noahkamara.abjc.consoleLogger")
            console.format = LogFormatter(.debug)
            log.add(console, withLevel: logLevel)

            // Set FileLogger
            let file = try FileLogger("com.noahkamara.abjc.fileLogger", fileURL: fileURL)
            console.format = LogFormatter(.debug)
            log.add(file, withLevel: logLevel)
        #else
            // SetConsoleLogger
            let console = ConsoleLogger("com.noahkamara.abjc.consoleLogger")
            console.format = LogFormatter(.console)
            log.add(console, withLevel: logLevel)

            // Set FileLogger
            let file = try FileLogger("com.noahkamara.abjc.fileLogger", fileURL: fileURL)
            console.format = LogFormatter(.file)
            log.add(file, withLevel: logLevel)
        #endif
    }
}
