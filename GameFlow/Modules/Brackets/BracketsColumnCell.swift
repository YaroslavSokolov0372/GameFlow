//
//  BracketsCoulmnCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 30/11/2023.
//


import SwiftUI
import ComposableArchitecture

struct BracketsColumnCellDomain: Reducer {
    
    
    struct State: Equatable {
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
        let bracketsColumn: [PandascoreBrackets]
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

struct BracketsColumnCell: View {
    
    var store: StoreOf<BracketsColumnCellDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            LazyVStack(spacing: 0){
                ForEach(viewStore.bracketsColumn, id: \.self) { bracket in
                    BracketCell(store: Store(
                        initialState: BracketCellDomain.State(
                            liquiTeams: viewStore.liquiTeams,
                            bracket: bracket
                        ), reducer: {
                        BracketCellDomain()
                    }))
                }
            }.task {
                print("bracket fount -", viewStore.bracketsColumn.count)
            }
        }
    }
}
//
//#Preview {
//    BracketsColumnCell(store: Store(initialState: BracketsColumnCellDomain.State(), reducer: {
//        BracketsColumnCellDomain()
//    }))
//}
