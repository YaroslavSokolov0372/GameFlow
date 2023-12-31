//
//  Team.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import Foundation

struct PandascoreTeam: Codable {
    
    let acronym: String?
    let id: Int
    let image_url: String?
    let location: String?
    let modified_at: String
    let name: String
    let players: [PandascorePlayer]
    let slug: String?
    
    struct PandascorePlayer: Codable, Equatable {
        let age: Int?
        let birthday: String?
        let first_name: String?
        let id: Int
        let image_url: String?
        let last_name: String?
        let name: String
        let nationality: String?
        let role: String?
        let slug: String?
    }
}

extension PandascoreTeam: Equatable {
    static func == (lhs: PandascoreTeam, rhs: PandascoreTeam) -> Bool {
        
        lhs.id == rhs.id
    }
}

extension PandascoreTeam: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension [PandascoreTeam] {
    
    func sameLiquiTeam(_ liquiTeams: [LiquipediaSerie.LiquipediaTeam]) -> [PandascoreTeam] {
        
        var sortedLiquiTeam = [PandascoreTeam]()
        
        for team in liquiTeams {
            if let pandaTeam = self.first(where: { $0.name.teamFormatted() == team.name.teamFormatted() }) {
                sortedLiquiTeam.append(pandaTeam)
            }
        }
        return sortedLiquiTeam
    }
}

extension PandascoreTeam {
    func formattedName() -> Self {
        if self.name == "Hustlers" {
            let newName = "The dudle Bouys"
            let newAcronym = "TDBOYS"
            let newTeam = PandascoreTeam(acronym: newAcronym , id: self.id, image_url: self.image_url, location: self.location, modified_at: self.modified_at, name: newName , players: self.players, slug: self.slug)

            return newTeam
        } else {
            return self
        }
    }
}
