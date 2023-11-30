//
//  BracketsCoulmnCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 30/11/2023.
//


import SwiftUI
import ComposableArchitecture

struct BracketsColumnCellDomain: Reducer {
    
    
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

struct BracketsColumnCell: View {
    
    var store: StoreOf<BracketsColumnCellDomain>
    
    var body: some View {
        LazyVStack(spacing: 0){
            ForEach(0..<5, id: \.self) { num in
                BracketCell(store: Store(initialState: BracketCellDomain.State(), reducer: {
                    BracketCellDomain()
                }))
            }
        }
    }
}

#Preview {
    BracketsColumnCell(store: Store(initialState: BracketsColumnCellDomain.State(), reducer: {
        BracketsColumnCellDomain()
    }))
}
