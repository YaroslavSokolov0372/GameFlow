//
//  LiqupediaSerie.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 16/11/2023.
//

import Foundation

struct LiquipediaSerie: Codable, Hashable {
    
    let name: String
    let prizepool: String
    let teams: [LiquipediaTeam]
    let tier: String
    
    struct LiquipediaTeam: Codable, Hashable, Equatable {
        
        let imageURL: String
        let name: String
        let players: [LiquipediaPlayer]
        
    }
    
    struct LiquipediaPlayer: Codable, Hashable {
        let nickname: String
        let flagURL: String
        let position: String
    }
    
    static func == (lhs: LiquipediaSerie, rhs: LiquipediaSerie) -> Bool {
        return lhs.name == rhs.name
    }
}
extension LiquipediaSerie {
    
    func getTournamentTeams(_ tournament: Tournament) -> [Self.LiquipediaTeam] {
        
        var liquiTeams: [Self.LiquipediaTeam] = []
        
        for team in self.teams {
            
            let filteredLiqui = team.name
            
            if tournament.teams!.contains(where: { $0.name.teamFormatted() == filteredLiqui.teamFormatted() }) {
                liquiTeams.append(team)
            }
        }
        return liquiTeams
    }
}

extension LiquipediaSerie.LiquipediaTeam {
    
    var hasTeamImage: Bool {
        if self.imageURL == "/commons/images/thumb/1/16/Dota2_logo.png/148px-Dota2_logo.png" {
            return false
        } else {
            return true
        }
    }
}

extension [LiquipediaSerie.LiquipediaTeam] {
    
    func getLiquiTeam(by name: String) -> LiquipediaSerie.LiquipediaTeam? {
        return self.first(where: { $0.name.teamFormatted() == name.teamFormatted() }) ?? nil
    }
}


