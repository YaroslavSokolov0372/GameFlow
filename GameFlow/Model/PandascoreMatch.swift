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
    let id: Int
    let live: Live
    let match_type: String
    let modified_at: String
    let name: String
    let number_of_games: Int
    let original_scheduled_at: String?
    let rescheduled: Bool?
    let scheduled_at: String?
    let slug: String?
    let status: String
    let streams_list: [StreamsList]
    let tournament_id: Int
    let winner_type: String
    

}

extension PandascoreMatch: Equatable {
    
    static func == (lhs: PandascoreMatch, rhs: PandascoreMatch) -> Bool {
        lhs.id == rhs.id
    }
}

extension PandascoreMatch: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct StreamsList: Codable {
    let embed_url: String?
    let language: String
    let main: Bool
    let official: Bool
    let raw_url: String
}

struct Live: Codable {
    let opens_at: String?
    let supported: Bool
    let url: String?
    
}
