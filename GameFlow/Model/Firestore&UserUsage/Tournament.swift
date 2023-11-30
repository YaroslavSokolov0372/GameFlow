//
//  Tournament.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import Foundation

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
