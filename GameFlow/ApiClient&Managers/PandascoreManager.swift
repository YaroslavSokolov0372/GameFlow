//
//  PandascoreManager.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/11/2023.
//

import Foundation
import Alamofire

enum PandascoreError: Error {
    case pandaInvalidURL
    case pandaFetchingFailed
}


class PandascoreManager {
    
    enum fetchType: String {
        case upciming = "upcoming"
        case ongoing = "running"
        case past = "past"
        case all = ""
    }
    
    let baseURL = "https://api.pandascore.co"
    
    func getPandaSeries(fetchType: fetchType) async throws -> [PandascoreSerie]  {
    
    guard let url = URL(string: "\(baseURL)/dota2/series/\(fetchType.rawValue)") else {
        print("Invalid URL")
        throw PandascoreError.pandaInvalidURL
    }
    
    do {
        let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
        
        let (data, _) = try await URLSession.shared.data(for: urlReq)
        
        let series = try JSONDecoder().decode([PandascoreSerie].self, from: data)
        
        
        print("series count \(fetchType.rawValue) - ", series.count)
        return series
        
    } catch {
        print(error)
    
        throw PandascoreError.pandaFetchingFailed
    }
}
    
    func getPandaSerieTournaments(_ serie: PandascoreSerie) async throws -> [PandascoreTournament] {
    
    var tournaments: [PandascoreTournament] = []
    
    for tournament in serie.tournaments {
        guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)") else {
            print("Failed url")
            throw PandascoreError.pandaInvalidURL
        }
        
        do {
            
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let tournament = try JSONDecoder().decode(PandascoreTournament.self, from: data)
            tournaments.append(tournament)
            
            print("Tournaments count -", tournaments.count)
            
        } catch {
            print(error)
            print("Failed to load tournaments for a serie")
            //                throw RequestError.fetchingFailed
            throw PandascoreError.pandaFetchingFailed
        }
    }
    return tournaments
}
        
    func getPandaTournamentTeams(_ tournament: PandascoreTournament) async throws -> [PandascoreTeam]? {
        
        guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)/teams") else {
            
            print("Invalid url for fetching teams")
            throw  PandascoreError.pandaInvalidURL
            
        }
        
        do {
            
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let teams = try? JSONDecoder().decode([PandascoreTeam].self, from: data)
            
            print("teams count, - ", teams == nil ? 0 : teams!.count )
            return teams
            
        } catch {
            //            print("Failed to fetch teams and create a tournament")
            throw PandascoreError.pandaFetchingFailed
            
        }
    }
    
    func getTournamentMatches(_ tournament: PandascoreTournament) async throws -> [PandascoreMatch]? {
        
        guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)/matches") else {
            print("Failed to load mathes for a tournaments")
            throw PandascoreError.pandaInvalidURL
        }
        
        do {
            
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let matches = try JSONDecoder().decode([PandascoreMatch].self, from: data)
            
//            print("matches count - \(matches?.count ?? 0)")
            return matches
            
        } catch {
//            print(error)
            print("Failed to fetch matches")
            throw PandascoreError.pandaFetchingFailed
        }
        
        
    }
    
    func getTournamentStandings(_ tournament: PandascoreTournament) async throws -> [PandascoreStandings]? {
        
        if tournament.has_bracket != true, tournament.has_bracket != nil {
            
            guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)/standings") else {
                
                print("Invalid url")
                throw PandascoreError.pandaInvalidURL
            }
            
            do {
                
                let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
                
                let (data, response) = try await URLSession.shared.data(for: urlReq)
                
                if let httpResponse = response as? HTTPURLResponse {
                    //                    print("statusCode: \(httpResponse.statusCode)")
                    
                    switch httpResponse.statusCode {
                    case 200 ... 299:
                        let standings = try? JSONDecoder().decode([PandascoreStandings].self, from: data)

                        return standings
                        
                    case 400 ... 422 :
                        return nil
                    default:
                        throw RequestError.fetchingFailed
                    }
                } else {
                    throw RequestError.fetchingFailed
                }
                
            } catch {
                
                print(error)
                print("Failed to fetch standings")
                throw RequestError.fetchingFailed
                
            }
        } else {
            return nil
        }
    }
    
    func getTournamentBrackets(_ tournament: PandascoreTournament) async throws -> [PandascoreBrackets]? {
        
        if tournament.has_bracket != nil, tournament.has_bracket == true {
            
            guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)/brackets") else {
                
                print("Invalid url")
                throw PandascoreError.pandaInvalidURL
            }
            
            do {
                let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
                
                let (data, _) = try await URLSession.shared.data(for: urlReq)
                
                let brackets = try? JSONDecoder().decode([PandascoreBrackets].self, from: data)
                
                print("Brackets count - ", brackets?.count ?? "nil")

                return brackets
                
            } catch {
                
                print(error)
                print("Failed to fetch brackets")
                throw PandascoreError.pandaFetchingFailed
                
            }
        } else {
            return nil
        }
    }
    
    func setupTournamentsFrom(_ serie: PandascoreSerie) async throws -> [Tournament] {
        
        
        var tournaments: [Tournament] = []
        let pandascoreTournaments = try await self.getPandaSerieTournaments(serie)
        
        try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
            for tournament in pandascoreTournaments {
                taskGroup.addTask {
                    let matches = try await self.getTournamentMatches(tournament)
                    let standings = try await self.getTournamentStandings(tournament)
                    let brackets = try await self.getTournamentBrackets(tournament)
                    let teams: [PandascoreTeam]? = try await self.getPandaTournamentTeams(tournament)
                    print("matches count - ", matches?.count)
                    return Tournament(tournament: tournament, teams: teams, matches: matches, standings: standings, brackets: brackets)
                }
            }
            
            for try await result in taskGroup {
                tournaments.append(result)
            }
        }
        return tournaments
    }
    
    
    func fetchRelevantPandaSeries() async throws -> [Serie] {
        
        var series: [Serie] = []
        let ongoingSeries = try await self.getPandaSeries(fetchType: .ongoing)
        let upcomingSeries = try await self.getPandaSeries(fetchType: .upciming)
        
        var allRelevant = ongoingSeries
        allRelevant.append(contentsOf: upcomingSeries)
        
        
        try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
            for pandaSerie in allRelevant {
                taskGroup.addTask {
                    
                    let tournaments = try await self.setupTournamentsFrom(pandaSerie)
                    
                    return Serie(serie: pandaSerie, tournaments: tournaments, liquipeadiaSerie: nil, imageName: DotaImages.allCases.randomElement()!.rawValue)
                }
                
            }
            
            
            for try await result in taskGroup {
                series.append(result)
            }
            
        }
        print(series.count)
        return series
    }
    
}



