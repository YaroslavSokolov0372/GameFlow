//
//  Team.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import Foundation

struct Team: Decodable {
    let acronym: String?
    let id: Int
    let image_url: String?
    let location: String?
    let modified_at: String
    let name: String
    let slug: String?
    
}

extension Team: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
