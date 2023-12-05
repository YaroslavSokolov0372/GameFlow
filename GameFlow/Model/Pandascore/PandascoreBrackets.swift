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


extension [PandascoreBrackets] {
    
    
    
    var upperBrackets: [String: [PandascoreBrackets]] {
        
        var stages: [String: [PandascoreBrackets]] = [:]
        let regex = "round\\S*(?:\\s\\S+)?"
        
        for bracket in self.reversed() {
            if bracket.name.contains("quarterfinal"), bracket.name.contains("Upper") {
                
                if let _ = stages["quarterfinal"] {
                    stages["quarterfinal"]!.append(bracket)
                } else {
                    stages["quarterfinal"] = [bracket]
                }
                
            } else if bracket.name.contains("semifinal"), bracket.name.contains("Upper") {
                
                if let _ = stages["semifinal"] {
                    stages["semifinal"]!.append(bracket)
                } else {
                    stages["semifinal"] = [bracket]
                }
                
            } else if bracket.name.contains("bracket final") {
                
                if let _ = stages["bracket final"] {
                    stages["bracket final"]!.append(bracket)
                } else {
                    stages["bracket final"] = [bracket]
                }
                
            } else if bracket.name.contains("final"), bracket.name.contains("Upper") {
                
                if let _ = stages["final"] {
                    stages["final"]!.append(bracket)
                } else {
                    stages["final"] = [bracket]
                }
                
            }
        }
        
        return stages
    }
    
    var lowerBrackets: [String: [PandascoreBrackets]] {
        
        var stages: [String: [PandascoreBrackets]] = [:]
        let regex = "round\\S*(?:\\s\\S+)?"
        
        for bracket in self.reversed()  {
            if bracket.name.contains("round") {
                
                let gameName = bracket.name.replacingOccurrences(of: regex, with: "", options: .regularExpression)
                let split = gameName.split(separator: " ")
                let last = String(split.suffix(1).joined(separator: [" "]))
                if let _ = stages[last] {
                    stages[last]!.append(bracket)
                    
                } else {
                    stages[last] = [bracket]
                }
            } else if bracket.name.contains("quarterfinal"), bracket.name.contains("Lower") {
                
                if let _ = stages["quarterfinal"] {
                    stages["quarterfinal"]!.append(bracket)
                } else {
                    stages["quarterfinal"] = [bracket]
                }
                
            } else if bracket.name.contains("semifinal"), bracket.name.contains("Lower") {
                
                if let _ = stages["semifinal"] {
                    stages["semifinal"]!.append(bracket)
                } else {
                    stages["semifinal"] = [bracket]
                }
                
            } else if bracket.name.contains("final"), bracket.name.contains("Lower") {
                
                if let _ = stages["final"] {
                    stages["final"]!.append(bracket)
                } else {
                    stages["final"] = [bracket]
                }
            }
        }
        return stages
    }
}


//"name": "Upper bracket semifinal 1: TBD vs TBD",
//"name": "Upper bracket final: TBD vs TBD",

