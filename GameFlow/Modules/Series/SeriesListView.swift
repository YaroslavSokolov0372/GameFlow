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
        var series: [Serie]
        var isFetching: Bool
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
                            .frame(height: 15)
                            .foregroundStyle(.clear)
                        
                        if viewStore.series.isEmpty {
                            
                            Text("There are no Series in this section")
                                .foregroundStyle(.white)
                                .font(.gilroy(.medium, size: 20))
                            
                        } else {

                                ForEach(viewStore.series, id: \.self) { serie in
                                    VStack {

                                        NavigationLink {
                                            
                                            DetailInfoView(store: Store(initialState: DetailInfoDomain.State(serie: serie), reducer: {
                                                DetailInfoDomain()
                                            })).navigationBarBackButtonHidden()
                                            
                                        } label: {
                                            SerieCellResketch(store: Store(initialState: SerieCellResketchDomain.State(isFetching: viewStore.isFetching, serie: serie), reducer: {
                                                SerieCellResketchDomain()
                                            }))
                                        }
                                        .disabled(viewStore.isFetching)

                                    }
                                    .frame(height: 320)
                                    
                                    
                                }
                            
                            //MARK: - Rectangle for TaBar not to ovelay on matches when scroll to bottom
                            Rectangle()
                                .frame(width: 370, height: 20)
                                .foregroundStyle(Color("Black", bundle: .main))
                        }
                    }
                }
                .scrollIndicators(.never)
                
        }
    }
}

//#Preview {
//    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
//        SeriesListDomain()
//    }))
//}
