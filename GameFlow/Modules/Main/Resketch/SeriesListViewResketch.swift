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
        @BindingState var series: [Serie] = []
    }
    
    enum Action {
        case serieTapped(Serie)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .serieTapped(let serie):
                print("Serie tapped")
                return .none
            default: return .none
            }
        }
    }
}

struct SeriesListViewResketch: View {

    var store: StoreOf<SeriesListResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.vertical) {
                VStack() {
                    Rectangle()
                        .frame(height: 75)
                        .foregroundStyle(.clear)
                    
                    
                    ForEach(viewStore.series, id: \.self) { serie in
                        VStack {
//                            NavigationLink(state: MainDomain.Path.State.detailInfo(.init())) {
                            
                            
                            NavigationLink {
                                
                                DetailInfoResketchView(store: Store(initialState: DetailInfoResketchDomain.State(serie: serie), reducer: {
                                    DetailInfoResketchDomain()
                                })).navigationBarBackButtonHidden()
                                
                            } label: {
                                SerieCellResketch(store: Store(initialState: SerieCellResketchDomain.State(serie: serie), reducer: {
                                    SerieCellResketchDomain()
                                }))
//                                .onTapGesture {
//                                    self.store.send(.serieTapped(serie))
//                                }
                                
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
    SeriesListViewResketch(store: Store(initialState: SeriesListResketchDomain.State(series: []), reducer: {
        SeriesListResketchDomain()
    }))
}
