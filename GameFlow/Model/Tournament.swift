//
//  Tournaments.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/10/2023.
//

import Foundation


//struct GameCell: Equatable {
//    let games: Game
//    let tournaments: [Tournament]
//}

struct Tournament: Decodable, Identifiable {
    
    let begin_at: String?
//    let detailed_stats: Bool
    let end_at: String?
    let has_bracket: Bool?
    let id: Int
//    let league: League
    let league_id: Int
    let live_supported: Bool
    let matches: [Match]
    let modified_at: String
    let name: String
    let prizepool: String?
//    let serie: Serie
    let serie_id: Int
    let slug: String
    let teams: [Team]
    let tier: String?
//    let videogame: Dictionary<String, StringOrIntType>
//    let videogame_title: VideoGameTitle?
    let winner_type: String?
    

}

extension Tournament: Equatable {
    static func == (lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
}

extension Tournament: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum StringOrIntType: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .string(container.decode(String.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .int(container.decode(Int.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(StringOrIntType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }


}



struct Videogame: Decodable {
    let id: Int
    let name, slug: String
}

struct VideoGameTitle: Decodable {
    let id: Int
    let name: String
    let slug: String
    let videogame_id: Int
    
}

enum VideoGame: Decodable {
    case id(Int)
    case name(String)
    case slug(String)
}



