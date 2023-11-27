//
//  PandascoreTournament.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 12/11/2023.
//

import Foundation


struct PandascoreTournament: Codable, Identifiable {
    
    let begin_at: String?
//    let detailed_stats: Bool
    let end_at: String?
    let has_bracket: Bool?
    let id: Int
//    let league: League
    let league_id: Int
    let live_supported: Bool
    let matches: [Self.PandascoreMatch]
    let modified_at: String
    let name: String
    let prizepool: String?
    let serie: Self.PandascoreSerie
    let serie_id: Int
    let slug: String
    let teams: [PandascoreTeam]
    let tier: String?
//    let videogame: Dictionary<String, StringOrIntType>
//    let videogame_title: VideoGameTitle?
    let winner_type: String?
    
    
    struct PandascoreSerie: Codable {
        let begin_at: String?
        let end_at: String?
        let full_name: String
        let id: Int
        let league_id: Int
        let modified_at: String
        let name: String?
        let season: String?
        let slug: String
        let winner_type: String?
        let year: Int?
    }
    
    struct PandascoreTeam: Codable {
        
        let acronym: String?
        let id: Int
        let image_url: String?
        let location: String?
        let modified_at: String
        let name: String
        let slug: String?
    }
    
    struct PandascoreMatch: Codable, Equatable, Hashable {
        
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
        
        static func == (lhs: PandascoreMatch, rhs: PandascoreMatch) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    }

//    extension PandascoreMatch: Equatable {
//        
//        static func == (lhs: PandascoreMatch, rhs: PandascoreMatch) -> Bool {
//            lhs.id == rhs.id
//        }
//    }

//    extension PandascoreMatch: Hashable {
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
//        }
//    }

}

extension PandascoreTournament: Equatable {
    static func == (lhs: PandascoreTournament, rhs: PandascoreTournament) -> Bool {
        lhs.id == rhs.id
    }
}

extension PandascoreTournament: Hashable {
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
