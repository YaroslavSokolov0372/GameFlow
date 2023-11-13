//
//  Serie.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/10/2023.
//

import Foundation


struct PandascoreSerie: Codable, Equatable, Hashable {
    
    //MARK: Codable properties
    let begin_at: String?
    let end_at: String?
    let full_name: String
    let id: Int
    let league: PandascoreLeague
    let league_id: Int
    let modified_at: String
    let name: String?
    let season: String?
    let slug: String
    let tournaments: [Self.PandascoreTournament]
    let winner_type: String?
    let year: Int?
    
    
    
    
    struct PandascoreTournament: Codable, Identifiable, Equatable {
        
        let begin_at: String?
        let detailed_stats: Bool
        let end_at: String?
        let has_bracket: Bool?
        let id: Int
//        let league: League
        let league_id: Int
        let live_supported: Bool
//        let matches: [Match]
        let modified_at: String
        let name: String
        let prizepool: String?
//        let serie: Serie
        let serie_id: Int
        let slug: String
        let tier: String?
        let winner_type: String?
//        let teams: [Team]
//        let tier: String?
//        let videogame: Dictionary<String, StringOrIntType>
//        let videogame_title: VideoGameTitle?
//        let winner_type: String?
        

    }
 
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    

    
}
