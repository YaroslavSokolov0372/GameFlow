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
    
    struct LiquipediaTeam: Codable, Hashable {
        
        let imageURL: String?
        let name: String?
        let players: [LiquipediaPlayer]?

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
