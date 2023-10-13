//
//  SearchQueryClient.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Alamofire


struct IconImage {
    
}


struct APIClient {
    
    var fetchOngoingTournaments: @Sendable () async throws -> [Serie]
    var fetchUpcomingTournaments: @Sendable () async throws -> [Serie]
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}


extension APIClient: DependencyKey {
    static var liveValue = APIClient {
        let baseURL = "https://api.pandascore.co"
        
        //MARK: - Fetch Games
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/dota2/series/running", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                .responseDecodable(of: [Serie].self) { response in
                    switch response.result {
                    case .success(let series):
                        print(series.count)
                        continuation.resume(returning: series)
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    } fetchUpcomingTournaments: {
        let baseURL = "https://api.pandascore.co"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/dota2/series/upcoming", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                .responseDecodable(of: [Serie].self) { response in
                    switch response.result {
                    case .success(let series):
                        print(series.count)
                        continuation.resume(returning: series)
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}



