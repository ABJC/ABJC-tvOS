//
//  API+Images.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import Foundation

extension API {
    public static func imageURL(
        _ jellyfin: Jellyfin,
        _ id: String,
        _ type: APIModels.ImageType,
        _ width: Int = 600) -> URL?
    {
        #if DEBUG
        Self.logger.info("[IMAGE] imageURL - called")
        Self.logger.debug("[IMAGE] imageURL - id=\(id), type=\(type.rawValue), width=\(width)")
        #endif
        
        let path = "/Items/\(id)/Images/\(type.rawValue)"
        let params = [
            "MaxWidth": String(width),
            "Format": "jpg",
            "Quality": String(70)
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = jellyfin.server.https ? "https" : "http"
        urlComponents.host = jellyfin.server.host
        urlComponents.port = jellyfin.server.port
        urlComponents.path = jellyfin.server.path ?? "" + path
        
        urlComponents.queryItems = params.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        guard let url = urlComponents.url else {
            Self.logger.error("[IMAGE] imageURL - failure 'Image URL Could not be created'")
            return nil
        }
        
        return url
    }
    
    
    public static func profileImageURL(
        _ jellyfin: Jellyfin,
        _ id: String) -> URL?
    {
        Self.logger.info("[IMAGE] profileImageURL - called")
        Self.logger.debug("[IMAGE] profileImageURL - id=\(id)")

        let path = "/Users/\(id)/Images/\(APIModels.ImageType.primary.rawValue)"
        let params = [
            "Format": "jpg",
            "Quality": String(70)
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = jellyfin.server.https ? "https" : "http"
        urlComponents.host = jellyfin.server.host
        urlComponents.port = jellyfin.server.port
        urlComponents.path = jellyfin.server.path ?? "" + path
        
        urlComponents.queryItems = params.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        guard let url = urlComponents.url else {
            Self.logger.error("[IMAGE] profileImageURL - failure 'Image URL Could not be created'")
            return nil
        }
        
        return url
    }
}
