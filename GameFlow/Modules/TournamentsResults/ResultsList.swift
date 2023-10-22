//
//  TournamentsResults.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct ResultsListDomain: Reducer {
    
    struct State: Equatable {
        var tournaments: [Tournament] = []
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

struct ResultsList: View {
    
    var store: StoreOf<ResultsListDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            VStack {
                ForEach(viewStore.tournaments, id: \.self) { tournament in
                    ResultsCell(store: Store(initialState: ResultsCellDomain.State(tournament: tournament), reducer: {
                        ResultsCellDomain()
                    }))
                    .padding(.bottom, 15)
                }
            }
        }
    }
}

#Preview {
    ResultsList(store: Store(initialState: ResultsListDomain.State(), reducer: {
        ResultsListDomain()
    }))
}
