//
//  Oponents.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import Foundation



struct PandascoreOpponents: Codable, Equatable {
    let opponent: Opponent
    let type: String
}

struct OpponentClass: Codable {
    let opponent: Opponent
}

struct Opponent: Codable {
    let acronym: String?
    let id: Int
    let image_url: String?
    let locatioin: String?
    let modified_at: String
    let name: String
    let slug: String?
}

extension OpponentClass: Equatable {
    
}

extension OpponentClass: Hashable {
    
}

//extension Opponent {
//    func getTournamentNameFrom(tournaments: [Tournament]) -> String {
//        var name: String = ""
//        for tournament in tournaments {
//            for match in tournament.matches {
//                if self.id == match.id {
//                    name = tournament.name
//                }
//            }
//        }
//        return name
//    }
//}


extension Opponent: Equatable {
    
}

extension Opponent: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

