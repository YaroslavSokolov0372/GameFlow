//
//  MatcchListView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct OngoingMatchListDomain: Reducer {
    
    struct State: Equatable {
        
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

struct OngoingMatchListView: View {
    
    var store: StoreOf<OngoingMatchListDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<5, id: \.self) { _ in
                        MatchCellView(store: Store(initialState: MatchCellDomain.State(), reducer: {
                            MatchCellDomain()
                        }))
                    }
                }
                .padding(.horizontal, 11)
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    OngoingMatchListView(store: Store(initialState: OngoingMatchListDomain.State(), reducer: {
        OngoingMatchListDomain()
    }))
}
