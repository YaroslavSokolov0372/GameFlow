//
//  PandascoreBrackets.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 12/11/2023.
//

import Foundation


struct PandascoreBrackets: Codable {
    
    let begin_at: String?
    let detailed_stats: Bool
    let draw: Bool
    let end_at: String?
    let forfeit: Bool
    let game_advantage: Int?
    let games: [Game]
    let id: Int
    let live: Live
    let match_type: String
    let modified_at: String
    let name: String
    let number_of_games: Int
    
    //MARK: chack opponents ???
//    let opponents: [Opponent]
    
    
    let original_scheduled_at: String?
    let scheduled_at: String?
    let slug: String?
    let status: String
    let streams_list: [StreamsList]
    let tournament_id: Int
    let winner_type: String
    
    
    struct Game: Codable {
        
        let begin_at: String?
        let complete: Bool
        let detailed_stats: Bool
        let end_at: String?
        let finished: Bool
        let forfeit: Bool
        let length: Int?
        let match_id: Int
        let position: Int
    }
    
}
