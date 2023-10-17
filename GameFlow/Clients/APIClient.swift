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
    
    var fetchOngoingSeries: @Sendable () async throws -> [Serie]
    var fetchUpcomingSeries: @Sendable () async throws -> [Serie]
    var fetchSeriesTournaments: @Sendable (Serie) async throws -> [Tournament]
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
//                        print(series.count)
                        continuation.resume(returning: series)
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    } fetchUpcomingSeries: {
        let baseURL = "https://api.pandascore.co"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/dota2/series/upcoming", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                .responseDecodable(of: [Serie].self) { response in
                    switch response.result {
                    case .success(let series):
//                        print(series.count)
                        continuation.resume(returning: series)
                        
                    case .failure(let error):
//                        switch error {
//                        case .invalidURL(let url):
//                            print("")
//                        default: return
//                        }
                        continuation.resume(throwing: error)
                    }
                }
        }
    } fetchSeriesTournaments: { serie in
        let baseURL = "https://api.pandascore.co"
        
        
        
        var tournaments: [Tournament] = []
        
//        return await withThrowingTaskGroup(of: [Tournament].self) { group -> [Tournament] in
            
        try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
            for tournament in serie.tournaments {
                taskGroup.addTask {
                     try await fetchSeriesTournament(tournamentId: tournament.id)
                }
            }
            
            for try await result in taskGroup {
                tournaments.append(result)
            }
        }
        return tournaments
//            for tournament in serie.tournaments {
////                group.addTask {
//                    AF.request("\(baseURL)/tournaments/\(tournament.id)", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
//                        .responseDecodable(of: Tournament.self) { response in
//                            switch response.result {
//                            case .success(let tournament):
////                                tournaments.append(tournament)
////                                return tournaments
//                                print("")
//                            case .failure(let error):
////                                return error
//                                print("")
//                            }
//                        }
////                }
//            }
//        }
        
            
        @Sendable func fetchSeriesTournament(tournamentId: Int) async throws -> Tournament {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request("\(baseURL)/tournaments/\(String(tournamentId))", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                    .responseDecodable(of: Tournament.self) { response in
                        switch response.result {
                        case .success(let tournaments):
                            continuation.resume(returning: tournaments)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        }
    }
}



