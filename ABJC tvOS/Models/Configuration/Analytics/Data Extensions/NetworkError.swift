//
//  ErrorResponse.swift
//  ErrorResponse
//
//  Created by Noah Kamara on 12.09.21.
//

import Foundation
import AnyCodable
import JellyfinAPI

class NetworkError: Encodable {
    private let error: ErrorResponse
    
    let type: String
    var data: [String: AnyEncodable] = [:]
    
    init(_ error: ErrorResponse) {
        self.error = error
        switch error {
            case .error(-1, _, _, let err):
                self.type = "url"
                data["code"] = .init(-1)
                data["error-code"] = .init(err._code)
                data["error-domain"] = .init(err._domain)
                
                switch err._code {
                    case -1001: data["error-label"] = "NetworkTimedOut"
                    case -1004: data["error-label"] = "UnableToConnect"
                    default: data["error-label"] = "Unknown (\(err._code)"
                }

            case .error(-2, _, _, let err):
                self.type = "http-url"
                data["code"] = .init(-2)
                data["error-code"] = .init(err._code)
                data["error-domain"] = .init(err._domain)
                
            case .error(let code, _, _, let err):
                self.type = "jellyfin"
                data["code"] = .init(code)
                data["error-code"] = .init(err._code)
                data["error-domain"] = .init(err._domain)
                
                switch code {
                    case 401: data["error-label"] = "Unauthorized"
                    default: data["error-label"] = "\(code)"
                }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    public func encode(to encoder: Encoder) throws {
        var encoderContainer = encoder.container(keyedBy: CodingKeys.self)
        try encoderContainer.encode(type, forKey: .type)
        try encoderContainer.encode(data, forKey: .data)
//        try encoderContainer.encode(timestamp, forKey: .timestamp)
//        try encoderContainer.encode(eventName, forKey: .eventName)
//        try encoderContainer.encode(eventData, forKey: .eventData)
//        try encoderContainer.encode(metadata, forKey: .metadata)
    }
}

extension DecodableRequestBuilderError {
    var typeDescription: String {
        print("TYPE", String(describing: self))
        switch self {
            case .emptyDataResponse: return String(describing: type(of: self))+".emptyDataResponse"
            case .nilHTTPResponse: return "nilHTTPResponse"
            case .unsuccessfulHTTPStatusCode: return "unsuccessfulHTTPStatusCode"
            case .jsonDecoding: return "jsonDecoding"
            case .generalError: return "generalError"
        }
    }
}
