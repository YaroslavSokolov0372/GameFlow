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


struct Serie {
    
    var serie: PandascoreSerie
    var tournaments: [Tournament]
    
    init(serie: PandascoreSerie, tournaments: [Tournament]) {
        self.serie = serie
        self.tournaments = tournaments
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

extension Serie {
    
//    func filter(serie: Self, tournaments: [Tournament], teams: [Team]) -> [Self] {
//        
//        var firestoreTournament = [Self]()
//        
////        for tournament in tournaments {
////            
////            let teams = teams.filter
////        }
//        return []
//    }
}

struct Brackets: Codable {
    
}

