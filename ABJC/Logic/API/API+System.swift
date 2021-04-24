//
//  API+System.swift
//  ABJC
//
//  Created by Noah Kamara on 26.03.21.
//

import Foundation

extension API {
    public static func systemInfo(
        _ jellyfin: Jellyfin,
        _ completion: @escaping (Result<APIModels.SystemInfo, Error>) -> Void)
    {
        Self.logger.info("[SYSTEM] systemInfo")
        API.request(jellyfin, "/System/Info", .get) { result in
            switch result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(APIModels.SystemInfo.self, from: data)
                        Self.logger.info("[SYSTEM] systemInfo - success")
                        completion(.success(object))
                    } catch {
                        Self.logger.error("[SYSTEM] systemInfo - failure \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public static func itemCounts(
        _ jellyfin: Jellyfin,
        _ completion: @escaping (Result<APIModels.ItemCounts, Error>) -> Void)
    {
        Self.logger.info("[SYSTEM] itemCounts")
        API.request(jellyfin, "/Items/Counts", .get) { result in
            switch result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(APIModels.ItemCounts.self, from: data)
                        Self.logger.info("[SYSTEM] itemCounts - success")
                        completion(.success(object))
                    } catch {
                        Self.logger.error("[SYSTEM] itemCounts - failure \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    
    public static func currentUser(
        _ jellyfin: Jellyfin,
        _ completion: @escaping (Result<APIModels.User, Error>) -> Void)
    {
        Self.logger.info("[SYSTEM] currentUser")
        API.request(jellyfin, "/Users/Me", .get) { result in
            switch result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(APIModels.User.self, from: data)
                        Self.logger.info("[SYSTEM] currentUser - success")
                        completion(.success(object))
                    } catch {
                        Self.logger.error("[SYSTEM] currentUser - failure \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
