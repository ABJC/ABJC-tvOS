/*
 ABJC - tvOS
 ViewDelegate.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 21.09.21
 */

import AnyCodable
import Combine
import Foundation
import JellyfinAPI
import SwiftUI

struct ErrorMessage: Identifiable {
    let code: Int
    let title: String
    let displayMessage: String

    var id: String {
        "\(code)\(title)\(displayMessage)"
    }

    /// If the custom displayMessage is `nil`, it will be set to the given logConstructor's message
    init(code: Int, title: String, displayMessage: String?) {
        self.code = code
        self.title = title
        self.displayMessage = displayMessage ?? "NO MESSAGE"
    }
}

class ViewDelegate: ObservableObject {
    @Environment(\.appConfiguration)
    var app

    let logger: Logger = .shared

    @ObservedObject
    var session: SessionStore = .shared

    @ObservedObject
    var preferences: PreferenceStore = .shared

    @Published
    var alert: AlertObject?

    @Published
    var isLoading = false
    @Published
    var errorMessage: ErrorMessage?

    var cancellables = Set<AnyCancellable>()

    init() {
        //        loading.loading.assign(to: \.isLoading, on: self).store(in: &cancellables)
    }

    func handleApiError(
        _ error: Error,
        with metadata: [String: AnyEncodable] = [:],
        function: String = #function,
        file: String = #file,
        line: UInt = #line
    ) {
        var metadata = metadata

        metadata["error-location"] = [
            "file": file,
            "line": line,
            "function": function
        ]

        #warning("better error logging")
        logger.log.error("error in \(function) L.\(line): \(error.localizedDescription)", tag: "ApiErrorHandling")

        if let errorResponse = error as? ErrorResponse {
            app.analytics.send(.networkError(errorResponse), with: metadata)
        } else {
            app.analytics.send(.unknownError(error), with: metadata)
        }
    }
}
