//
//  PandascoreManager.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/11/2023.
//

import Foundation


struct PandascoreManager {
    
    let baseURL = "https://api.pandascore.co"
    
    
    
    @Sendable func getPandaSeries() async throws -> [PandascoreSerie]  {
        
        guard let url = URL(string: "\(baseURL)/dota2/series/running") else {
            print("Invalid URL")
            //            throw RequestError.invalidURL
            return []
        }
        
        do {
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let series = try JSONDecoder().decode([PandascoreSerie].self, from: data)
            
            
            print("series count - ", series.count)
            return series
            
        } catch {
            print(error)
            return []
        }
    }
    
    @Sendable func getPandaSerieTournaments(_ serie: PandascoreSerie) async throws -> [PandascoreTournament] {
        
        var tournaments: [PandascoreTournament] = []
        
        for tournament in serie.tournaments {
            guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)") else {
                print("Failed url")
                throw RequestError.invalidURL
            }
            
            do {
                
                let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
                
                let (data, _) = try await URLSession.shared.data(for: urlReq)
                
                let tournament = try JSONDecoder().decode(PandascoreTournament.self, from: data)
                tournaments.append(tournament)
                
            } catch {
                print(error)
                print("Failed to load tournaments for a serie")
                //                throw RequestError.fetchingFailed
            }
        }
        print("Tournaments count -", tournaments.count)
        return tournaments
    }
    
    @Sendable func getPandaSeriesTournaments(_ series: [PandascoreSerie]) async throws -> [PandascoreTournament] {
        
        var tournaments: [PandascoreTournament] = []
        
        do {
            try await withThrowingTaskGroup(of: [PandascoreTournament].self) { taskGroup in
                for serie in series {
                    taskGroup.addTask {
                        try await getPandaSerieTournaments(serie)
                    }
                }
                
                
                
                for try await result in taskGroup {
                    tournaments.append(contentsOf: result)
                }
                
                
            }
            print("tournamntes count - ", tournaments.count)
            return tournaments
            
        } catch {
            //            print("Failed to load all tournaments")
            throw RequestError.fetchingFailed
            
        }
        
        
    }
    
    @Sendable func getPandaTournamentTeams(_ tournament: PandascoreTournament) async throws -> Tournament {
        
        guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.id)/teams") else {
            
            
            print("Invalid url for fetching teams")
            throw RequestError.invalidURL
        }
        
        do {
            
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let teams = try JSONDecoder().decode([PandascoreTeam].self, from: data)
            
            print("teams count, - ", teams.count)
            let tournament = Tournament(tournament: tournament, teams: teams)
            return tournament
            
        } catch {
            print("Failed to fetch teams and create a tournament")
            throw RequestError.fetchingFailed
            //            return []
        }
        
        
        
    }
    
    @Sendable func getPandaTournamentsTeams(_ tournaments: [PandascoreTournament]) async throws -> [Tournament] {
        
        var touramentsTeams: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        try await getPandaTournamentTeams(tournament)
                    }
                }
                
                for try await result in taskGroup {
                    touramentsTeams.append(result)
                }
            }
            
            return touramentsTeams
        } catch {
            print("Failed fetch all team")
            throw RequestError.fetchingFailed
        }
    }
    
    @Sendable func getTournamentMatches(_ tournament: Tournament) async throws -> Tournament {
        
        guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.tournament.id)/matches") else {
            print("Failed to load mathes for a tournaments")
            throw RequestError.invalidURL
            //            return []
        }
        
        do {
            let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
            
            let (data, _) = try await URLSession.shared.data(for: urlReq)
            
            let matches = try? JSONDecoder().decode([PandascoreMatch].self, from: data)
            
            print("matches count - \(matches?.count ?? 0)")
            var tournament = tournament
            tournament.matches = matches
            return tournament
        } catch {
            print("Failed to fetch matches")
            throw RequestError.fetchingFailed
        }
        
        
    }
    
    @Sendable func getTournamentsMatches(_ tournaments: [Tournament]) async throws -> [Tournament] {
        
        var tournamentsMatches: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        try await getTournamentMatches(tournament)
                    }
                }
                for try await result in taskGroup {
                    tournamentsMatches.append(result)
                    
                }
            }
            
            
            return tournamentsMatches
        } catch {
            print("Failed fetch all team")
            throw RequestError.fetchingFailed
        }
    }
    
    
    
    
    
    @Sendable func getTournamentStandings(_ tournament: Tournament) async throws -> Tournament {
        
        if 
            //            tournament.tournament.has_bracket != nil ||
            tournament.tournament.has_bracket != true {
            
            guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.tournament.id)/standings") else {
                
                print("Invalid url")
                throw RequestError.invalidURL
            }
            
            do {
                
                let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
                
                let (data, response) = try await URLSession.shared.data(for: urlReq)
                
                if let httpResponse = response as? HTTPURLResponse {
//                    print("statusCode: \(httpResponse.statusCode)")
                    
                    switch httpResponse.statusCode {
                    case 200 ... 299:
                        let standings = try JSONDecoder().decode([PandascoreStandings].self, from: data)
                        var tournament = tournament
                        tournament.standings = standings
                        return tournament
                        
                    case 404:
                        return tournament
                    default:
                        throw RequestError.fetchingFailed
                    }
                } else {
//                    var tournament = tournament
//                    tournament.standings = nil
//                    return tournament
                    throw RequestError.fetchingFailed
                }
                
                
                
                //                print(data.prettyPrintedJSONString!)
                //                print(String(data: response, encoding: .utf8) as Any)
                //                print(response)
                //                print(String(decoding: urlReq.httpBody ?? Data(), as: .utf8))
                //                print(standings)
                //                print("Standings count - \(String(describing: standings?.count ?? nil))")
                //                var tournament = tournament
                //                tournament.standings = standings
                //                return tournament
                
                
            } catch {
                
                print(error)
                print("Failed to fetch standings")
                throw RequestError.fetchingFailed
                
            }
        } else {
            return tournament
        }
    }
    
    @Sendable func getTournamentsStandings(_ tournaments: [Tournament]) async throws -> [Tournament] {
        
        var tournamentsStandings: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { groupTask in
                for tournament in tournaments {
                    groupTask.addTask {
                        try await getTournamentStandings(tournament)
                    }
                }
                
                for try await result in groupTask {
                    tournamentsStandings.append(result)
                }
            }
//            print("Standings count - ", tournamentsStandings.count)
            return tournamentsStandings
        } catch {
            print("Failed fetch all standings")
            throw RequestError.fetchingFailed
        }
    }
    
    @Sendable func getTournamentBrackets(_ tournament: Tournament) async throws -> Tournament {
        
        if tournament.tournament.has_bracket != nil, tournament.tournament.has_bracket == true {
            
            guard let url = URL(string: "\(baseURL)/tournaments/\(tournament.tournament.id)/brackets") else {
                
                print("Invalid url")
                throw RequestError.invalidURL
            }
            
            do {
                let urlReq = try URLRequest(url: url, method: .get, headers: [.authorization(bearerToken: Secrets.apiKey)])
                
                let (data, _) = try await URLSession.shared.data(for: urlReq)
                
                
                let brackets = try JSONDecoder().decode([PandascoreBrackets].self, from: data)
                
                print("Brackets count - ", brackets.count)
                var tournament = tournament
                tournament.brackets = brackets
                return tournament
                
            } catch {
                
                print(error)
                print("Failed to fetch brackets")
                throw RequestError.fetchingFailed
                
            }
        } else {
            return tournament
        }
    }
    
    @Sendable func getTournamentsBrackets(_ tournaments: [Tournament]) async throws -> [Tournament] {
        var tournamentsBrackets: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { groupTask in
                for tournament in tournaments {
                    groupTask.addTask {
                        try await getTournamentBrackets(tournament)
                    }
                }
                
                for try await result in groupTask {
                    tournamentsBrackets.append(result)
                }
            }
            print("Tournament's brackets count -", tournamentsBrackets.count)
            return tournamentsBrackets
        } catch {
            print("Failed fetch all brackets")
            throw RequestError.fetchingFailed
        }
    }
    
    
    
    @Sendable func getAllData() async throws -> ChampionShip {
        
        var championShips = ChampionShip(series: [])
        let pandaSeries = try await getPandaSeries()
        
        
        try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
            for pandaSerie in pandaSeries {
                taskGroup.addTask {
                    let tournaments = try await getPandaSerieTournaments(pandaSerie)
                    let tournamentsWithTeams = try await getPandaTournamentsTeams(tournaments)
                    let tournamentsWithMathes = try await getTournamentsMatches(tournamentsWithTeams)
                    let tournamentsWithStandings = try await getTournamentsStandings(tournamentsWithMathes)
                    let tournamentsWithBrackets = try await getTournamentsBrackets(tournamentsWithStandings)
                    return Serie(serie: pandaSerie, tournaments: tournamentsWithBrackets)
                }
                
            }
            
            for try await result in taskGroup {
                championShips.series.append(result)
            }
        }
        print("ChampionShip's series count, -", championShips.series.count)
        return championShips
    }
    
}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
