//
//  Authentication.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation


extension API {
    
    /// Authorize User
    /// - Parameters:
    ///   - server: Server Object
    ///   - client: Client Object
    ///   - username: Username
    ///   - password: Password
    ///   - completion: Authentication Result
    public static func authorize(
        _ server: Jellyfin.Server,
        _ client: Jellyfin.Client,
        _ username: String,
        _ password: String,
        _ completion: @escaping(Result<Jellyfin, Error>) -> Void)
    {
        Self.logger.info("[AUTH] authorize")
        Self.logger.debug("[AUTH] authorize - server=\(server.https ? "HTTPS" : "HTTP")://\(server.host):\(server.port) username=\(username)")
        // Make URL
        var urlComponents = URLComponents()
        urlComponents.scheme = server.https ? "HTTPS" : "HTTP"
        urlComponents.host = server.host
        urlComponents.port = server.port
        urlComponents.path = server.path ?? "" + "/Users/AuthenticateByName"
        
        guard let url = urlComponents.url else {
            fatalError("URL couldn't be created")
        }
        
        // Make Request
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        
        let version = "1.0.0"
        let authorization = [
            "Emby Client=ABJC",
            "Device=ATV",
            "DeviceId=\(client.deviceId)",
            "Version=\(version)"
        ]
        
        request.allHTTPHeaderFields = [
            "Content-type": "application/json",
            "X-Emby-Authorization": authorization.joined(separator: ", ")
        ]
        
        let jsonBody = [
            "Username": username,
            "Pw": password
        ]
        
        guard let data = try? JSONEncoder().encode(jsonBody) else {
            Self.logger.error("[AUTH] authorize - failure 'Could not encode JSON'")
            fatalError("Couldnt Encode JSON")
        }
        
        // Add Request Body
        request.httpBody = data
        
        // Session
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                Self.logger.info("[AUTH] authorize - failure '\(error.localizedDescription)'")
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    // Decode AuthResponse
                    let response = try JSONDecoder().decode(APIModels.AuthResponse.self, from: data)
                    
                    // Create User Object
                    let user = Jellyfin.User(response.user.id, response.serverId, response.accessToken)
                    
                    // Create Jellyfin Object
                    let jellyfin = Jellyfin(server, user, client)
                    
                    // Completion
                    Self.logger.info("[AUTH] authorize - success")
                    completion(.success(jellyfin))
                } catch {
                    let message = String(data: data, encoding: .utf8)
                    if message == "Error processing request." {
                        Self.logger.error("[AUTH] authorize - failure 'Could not process'")
                        completion(.failure(APIErrors.Authentication.failedAuthentication))
                    } else {
                        Self.logger.error("[AUTH] authorize - failure 'Unknown error'")
                        completion(.failure(APIErrors.Authentication.unknown))
                    }
                }
            }
        }.resume()
    }
}
