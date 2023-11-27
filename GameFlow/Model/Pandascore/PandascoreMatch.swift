//
//  Team.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import Foundation


struct PandascoreMatch: Codable {
        
    let begin_at: String?
    let detailed_stats: Bool
    let draw: Bool
    let end_at: String?
    let forfeit: Bool
    let game_advantage: Int?
    let games: [PandascoreGame]
    let id: Int
    let modified_at: String
    let name: String
    let number_of_games: Int
    let opponents: [PandascoreOpponents]
    let original_scheduled_at: String?
    let rescheduled: Bool?
    let results: [PandascoreResult]
    let scheduled_at: String?
    let serie_id: Int
    let slug: String?
    let status: String
    
}



//    let opponents: [PandaOpponents]

struct PandascoreGame: Codable {
    let begin_at: String?
    let complete: Bool
    let detailed_stats: Bool
    let end_at: String?
    let finished: Bool
    let forfeit: Bool
    let length: Int?
    let match_id: Int
    let position: Int
    let status: String
    let winner: PandascoreGameWinner
    
}

struct PandascoreGameWinner: Codable {
    let id: Int?
    let type: String?
}


struct PandascoreResult: Codable {
    let score: Int
    let team_id: Int
}

extension PandascoreMatch: Equatable {
    static func == (lhs: PandascoreMatch, rhs: PandascoreMatch) -> Bool {
        lhs.id == rhs.id
    }
}

extension PandascoreMatch: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension PandascoreMatch {
    
    func getLiquiTeam(teams: [LiquipediaSerie.LiquipediaTeam]) -> [PandascoreOpponents] {
        
        var prepOpponents: [PandascoreOpponents] = []
        
        
        if self.opponents.isEmpty {
            return []
        } else {
            for opponent in self.opponents {
                if teams.contains(where: { $0.name == opponent.opponent.name}) {
                    prepOpponents.append(opponent)
                }
            }
            return prepOpponents
        }
    }
    
    func matchTime() -> String {
        
        if let beginTime = self.begin_at {
            
            let startTime = beginTime.ISOfotmattedString()
            let usersTimeInISO = Date().iso8601.ISOfotmattedString()
            
            let calendar = Calendar(identifier: .iso8601)
            let components = calendar.dateComponents([.day, .hour, .minute], from: usersTimeInISO, to: startTime)
//            print(components)
            let days = components.day
            let minutes = components.minute
            let hours = components.hour
                
            var usersDate = Date()
            usersDate = calendar.date(byAdding: .minute, value: minutes ?? 0, to: usersDate)!
            usersDate = calendar.date(byAdding: .hour, value: hours ?? 0, to: usersDate)!
            usersDate = calendar.date(byAdding: .day, value: days ?? 0, to: usersDate)!
            
            return usersDate.matchFormat()
        }
        return "TBD"
    }
    
    func isMatchStarted() -> Bool {
        let calendar = Calendar(identifier: .iso8601)
        let currentTime = Date().iso8601.ISOfotmattedString()
        
        if let beginTime = self.begin_at {
//            print("Have begin")
            if let endTime = self.end_at {
                
                print(currentTime)
//                print("check is between")
                return currentTime.isBetween(beginTime.ISOfotmattedString(), and: endTime.ISOfotmattedString())
            } else {
//                print("check for 3 hours")
                let upTo3Hours = calendar.date(byAdding: .hour, value: 3, to: beginTime.ISOfotmattedString())
//                print(currentTime.isBetween(beginTime.ISOfotmattedString(), and: upTo3Hours!))
                return currentTime.isBetween(beginTime.ISOfotmattedString(), and: upTo3Hours!)
            }
        } else {
//            print("dont gave begin time")
            return false
        }
    }
    
    func calcScore(of opponent: Opponent) -> Int {
        
        var score: Int = 0
        
        for result in self.results {
            if result.team_id ==  opponent.id {
                score += result.score
            }
        }
        return score
    }
    
}


extension [PandascoreMatch] {
    
    var upToWeek: [PandascoreMatch] {
        
        var upcoming = [PandascoreMatch]()

        for match in self {
            if let beginDate = match.begin_at {
                let calendar = Calendar(identifier: .iso8601)
                let dayComponent = DateComponents(day: 7)
                let sevenDaysForw = calendar.date(byAdding: dayComponent, to: beginDate.ISOfotmattedString())
                let currentTime =  Date().ISO8601Format().ISOfotmattedString()
                
                if beginDate.ISOfotmattedString().isBetween(currentTime, and: sevenDaysForw!) {
                    upcoming.append(match)
                } else if match.status == "running" {
                    upcoming.append(match)
                }
            }
        }
        return upcoming.sorted(by: { $0.begin_at! < $1.begin_at!})
    }
}


