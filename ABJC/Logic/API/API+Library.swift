//
//  API+Library.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension API {
    
    /// Retrieve Items
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - type: MediaType for Item (Default: nil)
    ///   - completion: Result
    public static func items(
        _ jellyfin: Jellyfin,
        _ type: APIModels.MediaType? = nil,
        _ completion: @escaping (Result<[APIModels.MediaItem], Error>) -> Void)
    {
        Self.logger.info("[LIBRARY] items")
        Self.logger.debug("[LIBRARY] items - type=\(type != nil ? type!.rawValue : "all")")
        
        let path = "/Users/\(jellyfin.user.userId)/Items"
        
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Movie,Series",
            "Fields": "Genres,Overview"
        ]
        
        
        API.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.MediaItem]>.self, from: data)
                        Self.logger.info("[LIBRARY] items - success")
                        completion(.success(response.items))
                    } catch let error {
                        Self.logger.error("[LIBRARY] items - failure '\(error.localizedDescription)'")
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    
    /// Retrieve Latest Items
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - type: MediaType for Item (Default: nil)
    ///   - completion: Result
    public static func latest(
        _ jellyfin: Jellyfin,
        _ type: APIModels.MediaType? = nil,
        _ completion: @escaping (Result<[APIModels.MediaItem], Error>) -> Void)
    {
        Self.logger.info("[LIBRARY] latest")
        Self.logger.debug("[LIBRARY] latest - type=\(type != nil ? type!.rawValue : "all")")
        
        let path = "/Users/\(jellyfin.user.userId)/Latest"
        
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": "Movie",
            "Fields": "Genres,Overview"
        ]
        
        API.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.MediaItem]>.self, from: data)
                        Self.logger.info("[LIBRARY] latest - success")
                        completion(.success(response.items))
                    } catch let error {
                        Self.logger.error("[LIBRARY] latest - failure '\(error.localizedDescription)'")
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    /// Retrieve Movie Detail
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - id: Item ID
    ///   - completion: Result
    public static func movie(
        _ jellyfin: Jellyfin,
        _ id: String,
        _ completion: @escaping (Result<APIModels.Movie, Error>) -> Void)
    {
        Self.logger.info("[LIBRARY] movie")
        Self.logger.info("[LIBRARY] movie - id=\(id)")
        
        let path = "/Users/\(jellyfin.user.userId)/Items/\(id)"
        
        API.request(jellyfin, path, .get) { result in
            switch result {
                case .success(let data):
                    do {
                        let item = try JSONDecoder().decode(APIModels.Movie.self, from: data)
                        Self.logger.info("[LIBRARY] movie - success")
                        completion(.success(item))
                    } catch let error {
                        Self.logger.error("[LIBRARY] movie - failure '\(error.localizedDescription)'")
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    /// Retrieve Seasons
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - series_id: Series ID
    ///   - completion: Result
    public static func seasons(
        _ jellyfin: Jellyfin,
        _ series_id: String,
        _ completion: @escaping (Result<[APIModels.Season], Error>) -> Void)
    {
        Self.logger.info("[LIBRARY] seasons")
        Self.logger.debug("[LIBRARY] seasons - series_id=\(series_id)")
        
        let path = "/Shows/\(series_id)/Seasons"
        
        let params = [
            "userId": jellyfin.user.userId,
            "IncludeItemTypes": "Season",
            "SortOrder": "Ascending",
            "Fields": "Genres,Overview,People,CommunityRating"
        ]
        
        API.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let data = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.Season]>.self, from: data)
                        Self.logger.info("[LIBRARY] seasons - success")
                        completion(.success(data.items))
                    } catch let error {
                        Self.logger.error("[LIBRARY] seasons - failure '\(error.localizedDescription)'")
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    /// Retrieve Episodes
    /// - Parameters:
    ///   - jellyfin: Jellyfin Object
    ///   - series_id: Series ID
    ///   - completion: Result
    public static func episodes(
        _ jellyfin: Jellyfin,
        _ series_id: String,
        _ completion: @escaping (Result<[APIModels.Episode], Error>) -> Void)
    {
        Self.logger.info("[LIBRARY] episodes")
        Self.logger.debug("[LIBRARY] episodes - series_id=\(series_id)")

        let path = "/Shows/\(series_id)/Episodes"
        
        let params = [
            "userId": jellyfin.user.userId,
            "IncludeItemTypes": "Episode",
            "SortBy": "PremiereDate",
            "SortOrder": "Ascending",
            "Fields": "Genres,Overview,People,CommunityRating,MediaSources"
        ]
        
        API.request(jellyfin, path, .get, params) { result in
            switch result {
                case .success(let data):
                    do {
                        let data = try JSONDecoder().decode(APIModels.ItemResponse<[APIModels.Episode]>.self, from: data)
                        Self.logger.info("[LIBRARY] episodes - success")
                        completion(.success(data.items))
                    } catch let error {
                        Self.logger.error("[LIBRARY] episodes - failure '\(error.localizedDescription)'")
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
}
