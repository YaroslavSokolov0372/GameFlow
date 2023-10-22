//
//  ParticipantsCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 22/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct ParticipantsCellDomain: Reducer {
    struct State {
        
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

struct ParticipantsCellView: View {
    
    var store: StoreOf<ParticipantsCellDomain>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ParticipantsCellView(store: Store(initialState: ParticipantsCellDomain.State(), reducer: {
        ParticipantsCellDomain()
    }))
}
