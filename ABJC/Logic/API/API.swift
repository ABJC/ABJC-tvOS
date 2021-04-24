//
//  API.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation
import os

class API {
    /// Logger
    static var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "API")
    
    
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
            fatalError("URL couldn't be created")
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
                print(error)
                fatalError("Request failed with error")
//                completion(.failure(error))
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
