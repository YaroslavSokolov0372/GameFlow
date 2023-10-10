//
//  SearchQueryClient.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Alamofire



struct APIClient {
    
    var fetchGamges: @Sendable () async throws -> [Game]
    var fetchTournaments: @Sendable ([Game]) async throws -> [Game]
    
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}


extension APIClient: DependencyKey {
    static var liveValue = APIClient {
        let baseURL = "https://api.pandascore.co/"
        let result: [Game] = []
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/videogames",
                       method: .get,
                       headers: ["accept": "application/json",
                                 "Authorization": "Bearer \(Secrets.apiKey)"
                                ])
            .responseDecodable(of: [Game].self) { response in
                switch response.result {
                case .success(let games):
                    continuation.resume(returning: games)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    } fetchTournaments: { game in
        return game
    }
}

//extension APIClient: DependencyValues {
//    var APIClient: APIClient {
//        get { self[ApiClient.self] }
//        set { self[APIClient.self] = newValue }
//    }
//}



struct GamesClient {
    var search: (String) async throws -> [Game]
}


extension GamesClient {
    static let searchQuery = GamesClient { query in
        var components = URLComponents(string: "https://api.pandascore.co/videogames/")!
        
        return []
    }
}
