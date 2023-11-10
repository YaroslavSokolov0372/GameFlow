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
//                            NavigationLink(state: MainDomain.Path.State.detailInfo(.init())) {
                            NavigationLink {
                                
                                DetailInfoView(store: Store(initialState: DetailInfoDomain.State(), reducer: {
                                    DetailInfoDomain()
                                })).navigationBarBackButtonHidden()
                            } label: {
                                SerieCellView(store: Store(initialState: SerieCellDomain.State(), reducer: {
                                    SerieCellDomain()
                                }))
                                
                            }

                            
//                            }
                        }
                        .frame(height: 330)
                        
                    }
                    
                    
                    //MARK: - Rectangle for TaBar not to ovelay on matches when scroll to bottom
                    Rectangle()
                        .frame(width: 370, height: 40)
                        .foregroundStyle(Color("Black", bundle: .main))
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
