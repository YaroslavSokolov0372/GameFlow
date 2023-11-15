//
//  ChampionShip.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 11/11/2023.
//

import SwiftUI

struct ChampionShip {

    var series: [Serie]
    
    init(series: [Serie]) {
        self.series = series
    }
}

extension ChampionShip: Equatable {
}


struct Serie {
    
    var serie: PandascoreSerie
    var tournaments: [Tournament]
    
    init(serie: PandascoreSerie, tournaments: [Tournament]) {
        self.serie = serie
        self.tournaments = tournaments
    }
    
}

extension Serie: Hashable {
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }
}

extension Serie: Equatable {
    static func == (lhs: Serie, rhs: Serie) -> Bool {
        lhs.serie.id == rhs.serie.id
    }
}

extension Serie {
    
    var fullName: String {
            return "\(serie.league.name + " " + serie.full_name)"
    }
    
    var tier: String? {
        
        var newTier: String? = nil
        
        for tournament in self.tournaments {
            if let tier = tournament.tournament.tier {
                newTier = tier
            }
        }
        return newTier
    }
    
    var prizepool: String? {
        
        var newPrizepool: String? = nil
        for tournament in self.tournaments {
            
            if let prizepool = tournament.tournament.prizepool {
                newPrizepool = prizepool
            }
        }
        return newPrizepool?.capitalized
    }
    
    var duration: String {
        
        if let beginDate = serie.begin_at {
            
            let beginDate = beginDate.ISOfotmattedString().shortFormat()
            
            if let endDate = serie.end_at {
                
                let endDate = endDate.ISOfotmattedString().shortFormat()
                 
                return "\(beginDate) - \(endDate)"
            } else {
                return "\(beginDate) - ???"
            }
            
        } else {
            
            if let endDate = serie.end_at {
                
                let endDate = endDate.ISOfotmattedString().shortFormat()
            
                return "??? - \(endDate)"
                
            } else {
                return "??? - ???"
            }
        }
    }
    
    
    var sortedTournamentsByBegin: [Tournament] {
        
        let tournaments = self.tournaments.sorted(by: {
            $0.tournament.begin_at?.ISOfotmattedString() ?? Date() <
            $1.tournament.begin_at?.ISOfotmattedString() ?? Date()})
        
        return tournaments
    }
}



struct Tournament {
    
    var tournament: PandascoreTournament
    var teams: [PandascoreTeam]?
    var matches: [PandascoreMatch]?
    var standings: [PandascoreStandings]?
    var brackets: [PandascoreBrackets]?
    
    init(tournament: PandascoreTournament, teams: [PandascoreTeam]? = nil, matches: [PandascoreMatch]? = nil, standings: [PandascoreStandings]? = nil, brackets: [PandascoreBrackets]? = nil) {
        self.tournament = tournament
        self.teams = teams
        self.matches = matches
        self.standings = standings
        self.brackets = brackets
    }
    
}

extension Tournament {
        
    
    func getIndexOf(_ tournament: Tournament, from: [Tournament]) -> Int {
        return from.firstIndex(where: { $0.tournament.id == tournament.tournament.id }) ?? 0
    }
}



extension Tournament: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tournament.id)
    }
}


extension Tournament: Equatable {
    
    static func == (lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.tournament.id == rhs.tournament.id
    }
}


