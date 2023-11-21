//
//  PandascoreStandings.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 12/11/2023.
//

import Foundation

struct PandascoreStandings: Codable {
    
//    let standings: [PandascoreStandings]
    let losses: Int
    let rank: Int
    let team: Self.PandascoreTeam
//    let ties: Int
    let total: Int
    let wins: Int
    
    struct PandascoreTeam: Codable {
        
        let acronym: String?
        let id: Int
        let image_url: String?
        let location: String?
        let modified_at: String
        let name: String
        let slug: String?
    }
    
    
}

//struct PandaScoreSMTHBetween { 
//    
//    let group
//}


struct PandascoreGroupStangins: Codable {
    let losses: Int
    let rank: Int
    let team: PandascoreTeam
    let ties: Int
    let total: Int
    let wins: Int
}
