//
//  UpcomingMatchesList.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct UpcomingMatchesListDomain: Reducer {
    
    struct State: Equatable {
        var tournaments: [Tournament] = []
        var upcomingMatches: [Match] {
            
            var upcomingMatches: [Match] = []
            var matchesWithOutDefinedDate: [Match] = []
            let dateFormatter = ISO8601DateFormatter()
            
            for tournament in tournaments {
                for match in tournament.matches {
                    if let matchDate = match.begin_at {
                        let matchStart = dateFormatter.date(from: matchDate)!
                        let currentDate = Date()
                        let nextSevenDays = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
//                        if date.timeIntervalSinceNow.sign == .plus {
//                            upcomingMatches.append(match)
//                        }
                        if matchStart.isBetween(currentDate, and: nextSevenDays) {
                            upcomingMatches.append(match)
                        }
                    } else {
                        matchesWithOutDefinedDate.append(match)
                    }
                }
            }
            upcomingMatches.sort(by: { dateFormatter.date(from: $0.begin_at!)! < dateFormatter.date(from: $1.begin_at!)! })
            print("got \(upcomingMatches.count) matches")
            return upcomingMatches
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

struct UpcomingMatchesList: View {
    
    var store: StoreOf<UpcomingMatchesListDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(viewStore.upcomingMatches, id: \.self) { match in
                            HStack {
                                UpcomingMatchCell(store: Store(initialState: UpcomingMatchDomain.State(match: match, matchesTournament: match.getTournamentNameFrom(tournaments: viewStore.tournaments)), reducer: {
                                    UpcomingMatchDomain()
                                }))
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    UpcomingMatchesList(store: Store(initialState: UpcomingMatchesListDomain.State(), reducer: {
        UpcomingMatchesListDomain()
    }))
}
