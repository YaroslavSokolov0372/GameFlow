//
//  SeriesListViewResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture



struct SeriesListResketchDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var series: [Serie]
//        = Serie.sample
        @BindingState var isFetching: Bool
        
    }
    
    
    enum Action: BindableAction {
//        case serieTapped(Serie)
//        case serieTapped(Serie)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
//            case .serieTapped(let serie):
////                state.selSerie = serie
//                print("Serie tapped")
//                return .none
                
            case .binding(_):
                return .none
            default: return .none
                
            }
        }
        
        BindingReducer()
    }
}

struct SeriesListViewResketch: View {

    var store: StoreOf<SeriesListResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
                ScrollView(.vertical) {
                    VStack() {
                        
                        Rectangle()
                        //                        .frame(height: 75)
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
                                            
                                            DetailInfoResketchView(store: Store(initialState: DetailInfoResketchDomain.State(serie: serie), reducer: {
                                                DetailInfoResketchDomain()
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

#Preview {
    SeriesListViewResketch(store: Store(initialState: SeriesListResketchDomain.State( series: [], isFetching: false), reducer: {
        SeriesListResketchDomain()
    }))
}
