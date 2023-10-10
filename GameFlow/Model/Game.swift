//
//  Games.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import Foundation

struct Game: Decodable, Equatable {    
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
    
    let current_version: String?
    let id: Int
//    let leagues: [League]
    let name: String
    let slug: String
    
}

struct League: Decodable {
    
    let id: Int
    let image_url: String
    let name: String
    
}







