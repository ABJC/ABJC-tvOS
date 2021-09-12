//
//  Store.swift
//  Store
//
//  Created by Noah Kamara on 09.09.21.
//

import Foundation
import JellyfinAPI
import Combine
import SwiftUI
import AnyCodable


struct ErrorMessage: Identifiable {
    
    let code: Int
    let title: String
    let displayMessage: String
    
    var id: String {
        return "\(code)\(title)\(displayMessage)"
    }
    
    /// If the custom displayMessage is `nil`, it will be set to the given logConstructor's message
    init(code: Int, title: String, displayMessage: String?) {
        self.code = code
        self.title = title
        self.displayMessage = displayMessage ?? "NO MESSAGE"
    }
}

class ViewDelegate: ObservableObject {
    
    @Environment(\.appConfiguration) var app
    
    @ObservedObject var session: SessionStore = .shared
    @ObservedObject var preferences: PreferenceStore = .shared
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        //        loading.loading.assign(to: \.isLoading, on: self).store(in: &cancellables)
    }
    
    
    
    func handleApiError(_ error: Error, with metadata: [String: AnyEncodable] = [:], function: String = #function, file: String = #file, line: UInt = #line) {
        
        var metadata = metadata
        
        metadata["error-location"] = [
            "file": file,
            "line": line,
            "function": function
        ]
        
        if let errorResponse = error as? ErrorResponse {
            app.analytics.send(.networkError(errorResponse), with: metadata)
        }
        //        switch error {
        //            case .error(let statusCode, let data, let urlResponse, let error) as ErrorResponse:
        //                app.analytics.send(.apiError(statusCode, data, urlResponse, error))
        //
        //
        ////                print("DATA", data?.count)
        ////                print("ERR;", error)
        //            default: print("Unknown Error", type(of: error))
        //        }
    }
    //    func handleAPIRequestError(displayMessage: String? = nil, logLevel: LogLevel = .error, tag: String = "", function: String = #function, file: String = #file, line: UInt = #line, completion: Subscribers.Completion<Error>) {
    //        switch completion {
    //            case .finished:
    //                break
    //            case .failure(let error):
    //                if let errorResponse = error as? ErrorResponse {
    //                    print(errorResponse)
    //                    switch errorResponse {
    //                        case .error(-1, _, _, _):
    //
    //                            print("Request failed: URL request failed with error \(networkError.errorMessage.code): \(errorResponse.localizedDescription)")
    //                        case .error(-2, _, _, _):
    //                            networkError = .HTTPURLError(response: errorResponse, displayMessage: displayMessage)
    //                            print("Request failed: HTTP URL request failed with description: \(errorResponse.localizedDescription)")
    //                        default:
    //                            networkError = .JellyfinError(response: errorResponse, displayMessage: displayMessage)
    //                            // Able to use user-facing friendly description here since just HTTP status codes
    //                            print("Request failed: \(networkError.errorMessage.code) - \(networkError.errorMessage.title): \(networkError.errorMessage.displayMessage)\n\(error.localizedDescription)")
    //                    }
    //                    self.errorMessage = networkError.errorMessage
    //                }
    //        }
    //    }
}
