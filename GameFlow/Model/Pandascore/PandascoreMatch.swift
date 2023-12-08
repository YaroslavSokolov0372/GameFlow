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
    let streams_list: [StreamsList]
    
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
                let upTo2Hours = calendar.date(byAdding: .hour, value: 2, to: beginTime.ISOfotmattedString())
                return currentTime.isBetween(beginTime.ISOfotmattedString(), and: upTo2Hours!)
        } else {
            return false
        }
    }
    
    func isMatchFinished() -> Bool {
        let calendar = Calendar(identifier: .iso8601)
        let currentTime = Date().iso8601.ISOfotmattedString()
        
        if self.status == "finished" {
            return true
        } else if let endTime = self.end_at {
            let currentTime =  Date().ISO8601Format().ISOfotmattedString()
            if currentTime > endTime.ISOfotmattedString() {
                return true
            } else {
                return false
            }
        } else {
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
    
    var upciming: [PandascoreMatch] {
        
        var upcoming = [PandascoreMatch]()

        for match in self {
            if let beginDate = match.begin_at {
                let calendar = Calendar(identifier: .iso8601)
                let dayComponent = DateComponents(day: 7)
                let sevenDaysForw = calendar.date(byAdding: dayComponent, to: beginDate.ISOfotmattedString())
                let currentTime =  Date().ISO8601Format().ISOfotmattedString()
                let up2HoursAgo = calendar.date(byAdding: .hour, value: -2, to: currentTime)
                
                if beginDate.ISOfotmattedString().isBetween(up2HoursAgo!, and: sevenDaysForw!) {
                    upcoming.append(match)
                } else if match.status == "running" {
                    upcoming.append(match)
                } else if beginDate.ISOfotmattedString().isBetween(currentTime, and: sevenDaysForw!) {
                    upcoming.append(match)
                }
            }
        }
        return upcoming.sorted(by: { $0.begin_at! < $1.begin_at!})
    }
    
    var finished: [PandascoreMatch] {
        
        var matches = [PandascoreMatch]()
        
        for match in self {
            if  match.status == "finished" {
                matches.append(match)
            } else if let endTime = match.end_at {
                let currentTime =  Date().ISO8601Format().ISOfotmattedString()
                if currentTime > endTime.ISOfotmattedString() {
                    matches.append(match)
                }
            }
        }
        return matches.sorted(by: { $0.end_at! > $1.end_at!})
    }
    

    
    func getStandings(liquiInfo: LiquipediaSerie, tournament: Tournament) -> [Standings] {
        
        var standings = [Standings]()
            
        for match in self {
            if match.status == "finished" || match.status == "canceled" {
                
                if standings.contains(where: { $0.teamId == match.results[0].team_id }) {
                    
                    let firstTeamIndx = standings.firstIndex(where: { $0.teamId == match.results[0].team_id })!
                    var firstTeam = standings[firstTeamIndx]
                    
                    if standings.contains(where: { $0.teamId == match.results[1].team_id}) {
                        let secondTeamIndx = standings.firstIndex(where: { $0.teamId == match.results[1].team_id })!
                        var secondTeam = standings[secondTeamIndx]
                        
                        if match.status == "canceled" {
                            if firstTeam.wins > secondTeam.wins {
                                firstTeam.wins = firstTeam.wins + 2
                                
                                standings[secondTeamIndx] = secondTeam
                                standings[firstTeamIndx] = firstTeam
                            } else {
                                secondTeam.wins = secondTeam.wins + 2
                                standings[secondTeamIndx] = secondTeam
                                standings[firstTeamIndx] = firstTeam
                            }
                        } else {
                            
                            //                        secondTeam.looses = secondTeam.looses + firsTeam.wins
                            secondTeam.looses = secondTeam.looses + match.results.first(where: { $0.team_id == firstTeam.teamId})!.score
                            secondTeam.wins = secondTeam.wins + match.results.first(where: { $0.team_id == secondTeam.teamId})!.score
                            //                        firsTeam.looses = firsTeam.looses + secondTeam.wins
                            firstTeam.looses = firstTeam.looses + match.results.first(where: { $0.team_id == secondTeam.teamId})!.score
                            firstTeam.wins = firstTeam.wins + match.results.first(where: { $0.team_id == firstTeam.teamId})!.score
                            
                            standings[secondTeamIndx] = secondTeam
                            standings[firstTeamIndx] = firstTeam
                        }
                        
                    } else {
                        //DIDNT FIND SECOND TEAM
                        //FIND TEAM FROM LIQUI
                        let pandaTeam = tournament.teams?.first(where: { $0.id == match.results[1].team_id})
                        if let liquiTeam = liquiInfo.teams.getLiquiTeam(by: pandaTeam!.name) {
                            
                            standings.append(Standings(
                                name: liquiTeam.name,
                                teamId: match.results[1].team_id,
                                imageURL: liquiTeam.imageURL,
                                wins: match.results[1].score,
                                looses: firstTeam.wins))
                        }
                        
                        firstTeam.wins = firstTeam.wins + match.results.first(where: { $0.team_id == firstTeam.teamId})!.score
                        firstTeam.looses = firstTeam.looses + match.results[1].score
                        
                        standings[firstTeamIndx] = firstTeam
                    }
                    
                } else {
                    //DIDNT FIND FIRST TEAM
                    //FIND TEAM FROM LIQUI
                    if standings.contains(where: { $0.teamId == match.results[1].team_id}) {
                        let secondTeamIndx = standings.firstIndex(where: { $0.teamId == match.results[1].team_id })!
                        var secondTeam = standings[secondTeamIndx]
                        
                        let pandaTeam = tournament.teams?.first(where: { $0.id == match.results[0].team_id})
                        if let liquiTeam = liquiInfo.teams.getLiquiTeam(by: pandaTeam!.name) {
                            
                            standings.append(Standings(
                                name: liquiTeam.name,
                                teamId: match.results[0].team_id,
                                imageURL: liquiTeam.imageURL,
                                wins: match.results[0].score,
                                looses: secondTeam.wins))
                            
                        }
                        
                        secondTeam.wins = secondTeam.wins + match.results.first(where: { $0.team_id == secondTeam.teamId})!.score
                        secondTeam.looses = secondTeam.looses + match.results[0].score
                        
                        standings[secondTeamIndx] = secondTeam
                        
                    }
                    else {
                        //FIND TEAM FROM LIQUI
                        //DIDNT FIND ANY TEAM
                        let firstPandaTeam = tournament.teams!.first(where: { $0.id == match.results[0].team_id})!
                        if let firstLiquiTeam = liquiInfo.teams.getLiquiTeam(by: firstPandaTeam.name) {
                            
                            let secondPandaTeam = tournament.teams!.first(where: { $0.id == match.results[1].team_id})!
                            if let secondLiquiTeam = liquiInfo.teams.getLiquiTeam(by: secondPandaTeam.name) {
                                
                                standings.append(Standings(name: firstLiquiTeam.name, teamId: firstPandaTeam.id, imageURL: firstLiquiTeam.imageURL, wins: match.results[0].score, looses: match.results[1].score))
                                standings.append(Standings(name: secondLiquiTeam.name, teamId: secondPandaTeam.id, imageURL: secondLiquiTeam.imageURL, wins: match.results[1].score, looses: match.results[0].score))
                            } else {
                                //DIDNT FIND SECOND TEAM
                                standings.append(Standings(name: firstLiquiTeam.name, teamId: firstPandaTeam.id, imageURL: firstLiquiTeam.imageURL, wins: match.results[0].score, looses: match.results[1].score))
                            }
                        } else {
                            //DIDNT FIND FIRST TEAM
                            let secondPandaTeam = tournament.teams!.first(where: { $0.id == match.results[1].team_id})!
                            if let secondLiquiTeam = liquiInfo.teams.getLiquiTeam(by: secondPandaTeam.name) {
                                standings.append(Standings(name: secondLiquiTeam.name, teamId: secondPandaTeam.id, imageURL: secondLiquiTeam.imageURL, wins: match.results[1].score, looses: match.results[0].score))
                            }
                        }
                    }
                }
            }
        }
        return standings.sorted(by: { $0.wins > $1.wins })
    }
}


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


