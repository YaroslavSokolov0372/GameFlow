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
    let opponents: [PandascoreOpponents]
    
    
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

extension PandascoreBrackets: Equatable {
    static func == (lhs: PandascoreBrackets, rhs: PandascoreBrackets) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PandascoreBrackets: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension [PandascoreBrackets] {
    
    var upperBrackets: [String: [PandascoreBrackets]] {
        
        var stages: [String: [PandascoreBrackets]] = [:]
        
        for bracket in self {
            
            if bracket.name.contains("quarterfinal"), bracket.name.contains("Upper") {
                
                if let _ = stages["UPPER QUARTER-FINAL"] {
                    stages["UPPER QUARTER-FINAL"]!.append(bracket)
                } else {
                    stages["UPPER QUARTER-FINAL"] = [bracket]
                }
                
            } else if bracket.name.contains("semifinal"), bracket.name.contains("Upper") {
                
                if let _ = stages["UPPER SEMI-FINAL"] {
                    stages["UPPER SEMI-FINAL"]!.append(bracket)
                } else {
                    stages["UPPER SEMI-FINAL"] = [bracket]
                }
                
            } else if bracket.name.contains("bracket final"), bracket.name.contains("Upper") {
                
                if let _ = stages["UPPER BRACKET FINAL"] {
                    stages["UPPER BRACKET FINAL"]!.append(bracket)
                } else {
                    stages["UPPER BRACKET FINAL"] = [bracket]
                }
            } else if bracket.name.contains("Grand final") {
                if let _ = stages["GRAND FINAL"] {
                    stages["GRAND FINAL"]!.append(bracket)
                } else {
                    stages["GRAND FINAL"] = [bracket]
                }
            }
        }
        
        return stages
    }
    
    var lowerBrackets: [String: [PandascoreBrackets]] {
        
        var stages: [String: [PandascoreBrackets]] = [:]
        
        let regex = "round\\S*(?:\\s\\S+)?"
        
        for bracket in self {
            if bracket.name.contains("round") {
                let matched = matchesForRegexInText(for: regex, in: bracket.name)
                let split = matched.first!.split(separator: " ")
                let last = String(split.suffix(1).joined(separator: [" "]))
                if let _ = stages["LOWER ROUND \(last)"] {
                    stages["LOWER ROUND \(last)"]!.append(bracket)
                } else {
                    stages["LOWER ROUND \(last)"] = [bracket]
                }
            } else if bracket.name.contains("quarterfinal"), bracket.name.contains("Lower") {
                
                if let _ = stages["LOWER QUARTER-FINAL"] {
                    stages["LOWER QUARTER-FINAL"]!.append(bracket)
                } else {
                    stages["LOWER QUARTER-FINAL"] = [bracket]
                }
                
            } else if bracket.name.contains("semifinal"), bracket.name.contains("Lower") {
                
                if let _ = stages["LOWER SEMI-FINAL"] {
                    stages["LOWER SEMI-FINAL"]!.append(bracket)
                } else {
                    stages["LOWER SEMI-FINAL"] = [bracket]
                }
                
            } else if bracket.name.contains("final"), bracket.name.contains("Lower") {
                
                if let _ = stages["LOWER FINAL"] {
                    stages["LOWER FINAL"]!.append(bracket)
                } else {
                    stages["LOWER FINAL"] = [bracket]
                }
            }
        }
        return stages
    }
}


