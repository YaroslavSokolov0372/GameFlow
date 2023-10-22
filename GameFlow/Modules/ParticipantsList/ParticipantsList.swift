//
//  ParticipantsList.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 22/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct ParticipantsListDomain: Reducer {
    struct State {
        var tournaments: [Tournament] = []
        var filteredTeams: [Team] {
            var teams: [Team] = []
            for tournament in tournaments {
                for team in tournament.teams {
                    if !teams.contains(team) {
                        teams.append(team)
                    }
                }
            }
            return teams
        }
        var remaningTeams: [Team] {
            return []
        }
        var eliminatedTeams: [Team] {
            return []
        }
    }
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

struct ParticipantsList: View {
    
    var store: StoreOf<ParticipantsListDomain>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ParticipantsList(store: Store(initialState: ParticipantsListDomain.State(), reducer: {
        ParticipantsListDomain()
    }))
}




extension Team {
    func remaningTeams(from tournaments: [Tournament]) -> [Self] {
        
//        let sortedTournaments = sortedByTime(elements: tournaments)
        
//        if let latesTournament = sortedTournaments.last {
////            if let earliestTournament = sortedTournaments.first {
////                
////            }
//            let restTournaments = sortedTournaments.dropFirst(1)
//            
//            for tournament in restTournaments {
//                for teams in tournament.teams {
//                    
//                }
//            }
//        }
        
        for tournament in tournaments {
            if let beginAt = tournament.begin_at, let endAt = tournament.end_at {
                
            }
        }
        
        return []
    }
}

protocol TimeStamp {
    var begin_at: String? { get }
    var end_at: String? { get }
}

extension Tournament: TimeStamp {
    
}


func sortedByTime<T: TimeStamp>(elements: [T]) -> [T] {
    
    var undefinedTime: [T] = []
    var definedTime: [T] = []
    
    for element in elements {
        if  let _ = element.end_at {
            definedTime.append(element)
        } else {
            undefinedTime.append(element)
        }
    }
    
    let formatter = ISO8601DateFormatter()
    
    definedTime = definedTime.sorted ( by: {
        formatter.date(from: $0.end_at!)! < formatter.date(from: $1.end_at!)!
    })
    definedTime.append(contentsOf: undefinedTime)
    
    return definedTime
}

extension Date {
    var iso8601Date: String { return ISO8601DateFormatter().string(from: self)}
}
