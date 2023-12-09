//
//  Serie.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import Foundation

struct Serie {
    
    let imageName: String
    var liquipediaSerie: LiquipediaSerie?
    let serie: PandascoreSerie
    var tournaments: [Tournament]
    
    init(serie: PandascoreSerie, tournaments: [Tournament], liquipeadiaSerie: LiquipediaSerie?, imageName: String) {
        self.serie = serie
        self.tournaments = tournaments
        self.liquipediaSerie = liquipeadiaSerie
        self.imageName = imageName
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

extension [Serie] {
    
    var ongoing: [Serie] {
        
        var ongoingSeries = [Serie]()
        
        for serie in self {
            
            if let beginDate = serie.serie.begin_at, let endDate = serie.serie.end_at {
                
                let formattedBegin = beginDate.ISOfotmattedString()
                let formattedEnd = endDate.ISOfotmattedString()
                let currentDate = Date().iso8601.ISOfotmattedString()
                
                if currentDate.isBetween(formattedBegin, and: formattedEnd) {
                    ongoingSeries.append(serie)
                }
            }
        }
        
        return ongoingSeries.sorted(by: { $0.serie.begin_at! > $1.serie.begin_at! })
    }
    
    var upcoming: [Serie] {
        
        var upcomingSeries = [Serie]()
        
        for serie in self {
            
            if let beginDate = serie.serie.begin_at {
                
                let formattedBegin = beginDate.ISOfotmattedString()
                let currentDate = Date().iso8601.ISOfotmattedString()
                
                
                if currentDate < formattedBegin {
                    upcomingSeries.append(serie)
                }
            }
        }
        return upcomingSeries.sorted(by: { $0.serie.begin_at! > $1.serie.begin_at!})
    }
    
    var latest: [Serie] {
        
        var latestSeries = [Serie]()
        
        for serie in self {
            if let endDate = serie.serie.end_at {
                let calendar = Calendar(identifier: .iso8601)
                let formattedEnd = endDate.ISOfotmattedString()
                let currentDate = Date().iso8601.ISOfotmattedString()
                
                let limit = calendar.date(byAdding: .month, value: -1, to: currentDate)
                
//                if currentDate > formattedEnd {
                    if formattedEnd.isBetween(limit!, and: currentDate) {
                        latestSeries.append(serie)
//                    }
                }
            }
        }
        
        return latestSeries.sorted(by: { $0.serie.end_at! > $1.serie.end_at! })
    }
    
}

extension Serie {
    
    static let sample = [
        Serie(serie: PandascoreSerie(begin_at: "2023-11-18T21:00:00Z", end_at: "2023-11-18T21:00:00Z", full_name: "America season 8 2023", id: 4884, league: PandascoreLeague(id: 4884, image_url: nil, modified_at: "", name: "EPL World Series", slug: "dota-2-epl-world-series", url: nil ), league_id: 4884, modified_at: "", name: "America", season: "8", slug: "dota-2-epl-world-series-america-8-2023", tournaments: [], winner_type: "", year: 2023), tournaments: [], liquipeadiaSerie: LiquipediaSerie(name: "EPL World Series: America Season 8", prizepool: "$10,000", teams: [], tier: "Tier 3"), imageName: DotaImages.allCases.randomElement()!.rawValue),
        Serie(serie: PandascoreSerie(begin_at: "2023-11-18T21:00:00Z", end_at: "2023-11-18T21:00:00Z", full_name: "America season 8 2023", id: 4884, league: PandascoreLeague(id: 4884, image_url: nil, modified_at: "", name: "EPL World Series", slug: "dota-2-epl-world-series", url: nil ), league_id: 4884, modified_at: "", name: "America", season: "8", slug: "dota-2-epl-world-series-america-8-2023", tournaments: [], winner_type: "", year: 2023), tournaments: [], liquipeadiaSerie: LiquipediaSerie(name: "EPL World Series: America Season 8", prizepool: "$10,000", teams: [], tier: "Tier 3"), imageName: DotaImages.allCases.randomElement()!.rawValue)
    ]
    
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
            ($0.tournament.begin_at?.ISOfotmattedString() ?? Date(), $0.tournament.name) < ($1.tournament.begin_at?.ISOfotmattedString() ?? Date(), $1.tournament.name)})
        
//        let tournaments = self.tournaments.sorted(by: {
//            $0.tournament.begin_at?.ISOfotmattedString() ?? Date() < $1.tournament.begin_at?.ISOfotmattedString() ?? Date()})
        
        return tournaments
    }
}



