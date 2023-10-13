//
//  CurrentTournaments.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct TournamentsDomain: Reducer {
    struct State: Equatable {
        var tournaments: [Serie]
        var isFetching = true
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





struct TournamentsView: View {
    
    var store: StoreOf<TournamentsDomain>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    if viewStore.isFetching {
                        
                    } else {
                        ForEach(viewStore.tournaments, id: \.id) { serie in
                            TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: serie), reducer: {
                                TournamentViewCellDomain()
                            }))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TournamentsView(
        store: Store(initialState: TournamentsDomain.State(tournaments: []), reducer: {
        TournamentsDomain()
    }))
}
