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

//struct Tournament: Decodable, Identifiable {
//    
//    let begin_at: String?
//    let detailed_stats: Bool
//    let end_at: String?
//    let has_bracket: Bool
//    let id: Int
//    let league: League
//    let league_id: Int
//    let live_supported: Bool
//    let matches: [Match]
//    let modified_at: String
//    let name: String
//    let prizepool: String?
//    let serie: Serie
//    let serie_id: Int
//    let slug: String
//    let teams: [Team]
//    let tier: String?
//    let videogame: Dictionary<String, StringOrIntType>
//    let videogame_title: VideoGameTitle?
//    let winner_type: String?
//    
//
//}
//
//extension Tournament: Equatable {
//    static func == (lhs: Tournament, rhs: Tournament) -> Bool {
//        lhs.id == rhs.id
//    }
//}

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

struct Team: Decodable {
    let acronym: String?
    let id: Int
    let image_url: String?
    let location: String?
    let modified_at: String
    let name: String
    let slug: String?
    
}

struct Match: Decodable {
    
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
    
    struct StreamsList: Decodable {
        let embed_url: String?
        let language: String
        let main: Bool
        let official: Bool
        let raw_url: String
    }

    struct Live: Decodable {
        let opens_at: String?
        let supported: Bool
        let url: String?
        
    }
    
}


enum VideoGame: Decodable {
    case id(Int)
    case name(String)
    case slug(String)
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

//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .int(let int):
//            try container.encode(int)
//        case .string(let string):
//            try container.encode(string)
//        }
//    }
}

extension StringOrIntType: Equatable {
    
}

extension Array {
    func sortedByDate() -> Self {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ssZ"
        
        return self.sorted { firstElement, secondElement in
            dateFormatter.date(from: firstElement as! String)! > dateFormatter.date(from: secondElement as! String)!
        }
            
    }
}


//extension Tournament: Hashable {
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
