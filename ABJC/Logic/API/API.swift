//
//  API.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation
import os
import AnalyticsClient

extension API {
    public enum Methods {
        // Authentication
        case authorize
        
        // System Info
        case systemInfo
        case itemCounts
        case publicUsers
        case currentUser
        
        // Library
        case items
        case latest
        case movie
        case seasons
        case episodes
        
        // Images
        case imageURL
        case profileImageURL
        
        // Playback
        case playerItem
        case reportPlaystate
        
        // Search
        case searchItems
        case searchPeople
        
        var rawValue: String {
            return String(describing: self)
        }
        
        var detail: [String: String] {
            return [
                "class": "API",
                "method": String(describing: self)
            ]
        }
    }
}

class API {
    /// Logger
    static var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "API")
    
    public static func logError(method: API.Methods, error: Error, session: SessionStore, in view: ViewIdentifier) {
        if let error = error as? DecodingError {
            session.analytics.log(.decodingError(error), in: .moviePage, with: method.detail)
        } else {
            print("ANALYTICS: UNKNOWN ERROR")
            session.analytics.log(.unknownError(error), in: view, with: method.detail)
        }
    }
    
    /// Request Ressource from Server
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - path: Request Path
    ///   - method: Request Method
    ///   - params: Request Query Items
    /// - Returns: Request Data
    public static func request(
        _ jellyfin: Jellyfin,
        _ path: String,
        _ method: HTTPMethod,
        _ params: [String: String?] = [:],
        _ payload: Data? = nil,
        _ completion: @escaping (Result<Data, Error>) -> Void)
    {
        // Make URL
        var urlComponents = URLComponents()
        urlComponents.scheme = jellyfin.server.https ? "https" : "http"
        urlComponents.host = jellyfin.server.host
        urlComponents.port = jellyfin.server.port
        urlComponents.path = jellyfin.server.path ?? "" + path
        
        // URL Query Parameters
        urlComponents.queryItems = params.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        guard let url = urlComponents.url else {
            self.logger.fault("Couldn't construct URL from componenets")
            completion(.failure(APIErrors.failedUrlConstruction))
            return
        }
        
        // Make Request
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if let payload = payload {
            request.httpBody = payload
        }
        
        let version = "1.0.0"
        let authorization = [
            "Emby Client=ABJC",
            "Device=ATV",
            "DeviceId=\(jellyfin.client.deviceId)",
            "Version=\(version)"
        ]
        
        request.allHTTPHeaderFields = [
            "Content-type": "application/json",
            "X-Emby-Authorization": authorization.joined(separator: ", "),
            "X-Emby-Token": jellyfin.user.accessToken
        ]
        
        request.timeoutInterval = 30.0
        
        // Session
        let session = URLSession.shared
        
        Self.logger.debug("[\(request.httpMethod ?? "GET")] \(urlComponents.path)")
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300) {
                    print("STATUS CODE ERROR")
                }
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
