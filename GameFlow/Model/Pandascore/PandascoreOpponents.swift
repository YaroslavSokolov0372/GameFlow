//
//  PandascoreOpponents.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import Foundation

struct PandascoreOpponents: Codable, Equatable {
    let opponent: Opponent
    let type: String
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

extension Opponent: Equatable {
    
}

extension PandascoreOpponents: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(opponent.id)
    }
}

