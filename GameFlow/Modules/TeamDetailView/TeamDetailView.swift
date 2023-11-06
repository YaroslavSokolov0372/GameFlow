//
//  TeamDetailView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TeamDetailDomain: Reducer {
    
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

struct TeamDetailView: View {
    
    var store: StoreOf<TeamDetailDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    TeamDetailView(store: Store(initialState: TeamDetailDomain.State(), reducer: {
        TeamDetailDomain()
    }))
}
