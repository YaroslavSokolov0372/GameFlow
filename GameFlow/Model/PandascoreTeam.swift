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

