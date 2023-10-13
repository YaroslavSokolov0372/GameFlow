//
//  Games.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import Foundation


struct Game: Decodable {
    
    let current_version: String?
    let id: Int
    let leagues: [League]
    let name: String
    let slug: String
}


extension Game: Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
}




























