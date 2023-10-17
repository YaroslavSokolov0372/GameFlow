//
//  CurrentTournaments.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SeriesListDomain: Reducer {
    struct State: Equatable {
        var series: [Serie] = []
        let apiFetchType: ApiCallType
        var isFetching = false
        var playLoadingAnimation = false
    }
    
    enum Action {
        case startedFetching
        case finishedFetching
        case playLoadingAnimation
        case fetchSeries
        case fetchSeriesRespons(TaskResult<[Serie]>)
        case seriesViewTapped(Serie)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    enum ApiCallType {
        case ongoingSeries
        case upcommingSeries
    }
    
    var body: some Reducer<State, Action> {
        
        
        Reduce { state, action in
            switch action {
            case .startedFetching:
                //                print(state.isFetching)
                if state.series.isEmpty {
                    state.isFetching = true
                    return .run { send in
                        await send(.playLoadingAnimation, animation: .linear(duration: 4).repeatForever(autoreverses: false))
                    }
                } else {
                    return .none 
                }
                
            case .finishedFetching:
                
                state.isFetching = false
                return .none
                
            case .playLoadingAnimation:
                state.playLoadingAnimation = true
                return .none
                
            case .fetchSeries:
                switch state.apiFetchType {
                case .ongoingSeries:
                    if state.series.isEmpty {
                        return .run { send in
                            try await Task.sleep(for: .seconds(2))
                            await send(.fetchSeriesRespons(TaskResult { try await apiClient.fetchOngoingSeries() }))
                        }
                    } else {
                        return .none
                    }
                case .upcommingSeries:
                    return .run { send in
                        await send(.fetchSeriesRespons(TaskResult { try await apiClient.fetchUpcomingSeries() }))
                    }
                }
            case .fetchSeriesRespons(.success(let series)):
                state.series = series
                state.isFetching = false
                return .none
            case .fetchSeriesRespons(.failure(let error)):
                state.isFetching = false
                return .none
                
                
//            case .tournamentsViewTapped:
//
//                print("tapped on tournament")
//                return .none
            case .seriesViewTapped(let serie):
//                print(serie)
                return .none

            }
        }
    }
}





struct SeriesListView: View {
    
    var store: StoreOf<SeriesListDomain>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if viewStore.isFetching {
                        ForEach(0..<6, id: \.self) { _ in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.searchBack)
                                    .frame(width: UIScreen.main.bounds.width / 1.16, height: 300)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(.gameListCellForeground)
                                            .frame(width: UIScreen.main.bounds.width / 0.84, height: 150)
                                            .rotationEffect(.degrees(viewStore.playLoadingAnimation ? 360 : 0))
                                            .mask {
                                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                                    .stroke(lineWidth: 5)
                                                    .frame(width: UIScreen.main.bounds.width / 1.16, height: 295)
                                            }
                                    }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.17, height: 300, alignment: .leading)
                        
                    } else {
                        ForEach(viewStore.series, id: \.id) { serie in
                                TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: serie), reducer: {
                                    TournamentViewCellDomain()
                                }))
                                .onTapGesture {
                                    viewStore.send(.seriesViewTapped(serie))
                                }
                        }
                        
                    }
                }
                .padding(.horizontal)
                .task {
                    viewStore.send(.startedFetching)
//                    do {
//                        try await Task.sleep(for: .seconds(2))
                        await viewStore.send(.fetchSeries).finish()
//                    } catch {
//                    }
                }
                .onAppear(perform: {
                    print(viewStore.state.series.count)
                })
            }
        }
    }
}

#Preview {
    SeriesListView(
        store: Store(initialState: SeriesListDomain.State(series: [], apiFetchType: .ongoingSeries), reducer: {
        SeriesListDomain()
    }))
}


//                    if viewStore.isFetching == false {
//                        ForEach(viewStore.tournaments, id: \.id) { serie in
//                            TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: serie), reducer: {
//                                TournamentViewCellDomain()
//                            }))
//                        }
//                    }
