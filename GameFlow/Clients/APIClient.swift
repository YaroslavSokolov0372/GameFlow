//
//  SearchQueryClient.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Alamofire


fileprivate let baseURL = "https://api.pandascore.co"


//MARK: - Basic fetch for pandascore
/// fetch upcomingSeries
/// fetch runningSeries
/// fetch pastSeries
/// fetch tournaments for each Series
/// fetch roasters(or teams) for a tournaments
/// fetch brackets if exist, if don't, then standings
/// fetch matches for tournaments

//So, firstly I make request to firebase to check last dateStamp to know when last time was fetching pandascor
// if last time was more than 1 hour, then go fetch daata from pandascore and rewrite to firebase, if less, then fetch from firebase


//Exception:
// if there is a match which will start in 15 minutes or less, then fetch from pandascore to check if it was reschedule or not
//

struct APIClient {
    
    
    var fetchOngoingSeries: @Sendable () async throws -> [Serie]
    var fetchUpcomingSeries: @Sendable () async throws -> [Serie]
    var fetchSeriesTournaments: @Sendable (Serie) async throws -> [Tournament]
    var fetchTeamsForUpcomingGame: @Sendable (Match) async throws -> [OpponentClass]
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}





extension APIClient: DependencyKey {
    static var liveValue = APIClient {
//        let baseURL = "https://api.pandascore.co"
        
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
//        let baseURL = "https://api.pandascore.co"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/dota2/series/upcoming", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                .responseDecodable(of: [Serie].self) { response in
                    switch response.result {
                    case .success(let series):
                        continuation.resume(returning: series)
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    } fetchSeriesTournaments: { serie in
        let baseURL = "https://api.pandascore.co"
        
        
        
        var tournaments: [Tournament] = []
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
    } fetchTeamsForUpcomingGame: { matche in
//        
//        var oponents: [Oponents] = []
//        
//        try await withThrowingTaskGroup(of: [Oponents].self) { taskGroup in
//            for match in matches {
//                taskGroup.addTask {
//                    try await fetchUpcomingMatches(matchId: match.id)
//                }
//            }
//            
//            for try await result in taskGroup {
//                
//                oponents.append(contentsOf: result)
//            }
//        }
//        print(oponents.count)
//        return oponents
        
//        @Sendable func fetchUpcomingMatches(matchId: Int) async throws -> [Oponents] {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request("\(baseURL)/matches/\(String(matche.id))", method: .get, headers: ["accept": "application/json", "Authorization": "Bearer \(Secrets.apiKey)"])
                    .responseDecodable(of: OponentsOfMatch.self) { response in
                        switch response.result {
                        case .success(let oponents):
                            continuation.resume(returning: oponents.opponents)
                            
                        case .failure(let error):
                            print(error)
                            continuation.resume(throwing: error)
                            
                        }
                    }
            }
        }
//    }
}






