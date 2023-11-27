//
//  OngoingMatchListViewResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct OngoingMatchListResketchDomain: Reducer {
    
    struct State: Equatable {
        let matches: [PandascoreMatch]
        let liquiInfo: [LiquipediaSerie.LiquipediaTeam]
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

struct OngoingMatchListViewResketch: View {
    
    var store: StoreOf<OngoingMatchListResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            if viewStore.matches.isEmpty {
                NoUpcomingMatchesView()
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(viewStore.matches, id: \.self) { match in
                            MatchCellResketchView(store: Store(initialState: MatchCellResketchDomain.State(match: match, liquiTeams: viewStore.liquiInfo), reducer: {
                                MatchCellResketchDomain()
                            }))
                        }
                    }
                    .padding(.horizontal, 11)
                }
                .scrollIndicators(.never)
            }
        }
    }
}

//#Preview {
//    OngoingMatchListViewResketch(store: Store(initialState: OngoingMatchListResketchDomain.State(matches: [], liquiTeams: <#LiquipediaSerie#>), reducer: {
//        OngoingMatchListResketchDomain()
//    }))
//}
