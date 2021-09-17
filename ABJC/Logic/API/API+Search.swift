//
//  API+Search.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import Foundation

extension API {
    public static func searchItems(
        _ jellyfin: Jellyfin,
        _ query: String,
        _ completion: @escaping ((Result<[APIModels.MediaItem], Error>) -> Void)
    ) {
        Self.logger.info("[SEARCH] searchItems - called")
        Self.logger.debug("[SEARCH] searchItems - query=\(query)")
        
        let path = "/Users/\(jellyfin.user.userId)/Items"
        let params = [
            "searchTerm": query,
            "IncludeItemTypes": "Series,Movie",
            "Recursive": String(true),
            "Fields": "Genres",
            "Limit": String(24)
        ]
        
        Self.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.MediaItem]>.self, from: data)
                        Self.logger.info("[SEARCH] searchItems - success")
                        completion(.success(object.items))
                    } catch {
                        Self.logger.error("[SYSTEM] searchItems - failure \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public static func searchPeople(
        _ jellyfin: Jellyfin,
        _ query: String,
        _ completion: @escaping ((Result<[APIModels.Person], Error>) -> Void)
    ) {
        Self.logger.info("[SEARCH] searchPeople - called")
        Self.logger.debug("[SEARCH] searchPeople - query=\(query)")
        
        let path = "/Persons"
        let params = [
            "searchTerm": query,
            "IncludeItemTypes": "Person",
            "Recursive": String(true),
            "Fields": "Genres",
            "Limit": String(24)
        ]
        
        Self.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.Person]>.self, from: data)
                        Self.logger.info("[SEARCH] searchPeople - success")
                        completion(.success(object.items))
                    } catch {
                        Self.logger.error("[SYSTEM] searchPeople - failure \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
