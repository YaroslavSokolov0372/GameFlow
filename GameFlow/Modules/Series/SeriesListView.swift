//
//  SeriesListView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 31/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SeriesListDomain: Reducer {
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

struct SeriesListView: View {
    var store: StoreOf<SeriesListDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.vertical) {
                VStack() {
                    Rectangle()
                        .frame(height: 75)
                        .foregroundStyle(.clear)
                    
                    
                    ForEach(0..<4, id: \.self) { tournament in
                        VStack {
                            SerieCellView(store: Store(initialState: SerieCellDomain.State(), reducer: {
                                SerieCellDomain()
                            }))
                        }
                        .frame(height: 330)
                        
                    }
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
        SeriesListDomain()
    }))
}
