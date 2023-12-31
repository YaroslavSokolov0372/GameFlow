//
//  League.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/10/2023.
//

import Foundation



struct PandascoreLeague: Codable {
    
    let id: Int
    let image_url: String?
    let modified_at: String
    let name: String
//    let series: [Serie]?
    let slug: String
    let url: String?
    
    
    
}

extension PandascoreLeague: Equatable {
    static func == (lhs: PandascoreLeague, rhs: PandascoreLeague) -> Bool {
        lhs.id == rhs.id
    }
}
