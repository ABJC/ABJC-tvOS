/*
 ABJC - tvOS
 LogFileRotationDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 06.10.21
 */

import Foundation
import Puppy

class LogFileRotationDelegate: FileRotationLoggerDeletate {
    func fileRotationLogger(_: FileRotationLogger, didArchiveFileURL: URL, toFileURL: URL) {
        print("didArchiveFileURL: \(didArchiveFileURL), toFileURL: \(toFileURL)")
    }

    func fileRotationLogger(_: FileRotationLogger, didRemoveArchivedFileURL: URL) {
        print("didRemoveArchivedFileURL: \(didRemoveArchivedFileURL)")
    }
}
