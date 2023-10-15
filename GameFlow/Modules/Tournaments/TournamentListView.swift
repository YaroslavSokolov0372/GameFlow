//
//  CurrentTournaments.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct TournamentListDomain: Reducer {
    struct State: Equatable {
        var tournaments: [Serie] = []
        let apiFetchType: ApiCallType
        var isFetching = false
        var playLoadingAnimation = false
    }
    
    enum Action {
        case startedFetching
        case finishedFetching
        case playLoadingAnimation
        case fetchTournaments
        case fetchTournamentsRespons(TaskResult<[Serie]>)

    }
    
    @Dependency(\.apiClient) var apiClient
    
    enum ApiCallType {
        case ongoingTournaments
        case upcommingTournaments
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startedFetching:
                state.isFetching = true
                print(state.isFetching)
                return .run { send in
                    await send(.playLoadingAnimation, animation: .linear(duration: 4).repeatForever(autoreverses: false))
                }
                
            case .finishedFetching:
                
                state.isFetching = false
                return .none
                
            case .playLoadingAnimation:
                state.playLoadingAnimation = true
                return .none
                
            case .fetchTournaments:
                switch state.apiFetchType {
                case .ongoingTournaments:
                    return .run { send in
                        await send(.fetchTournamentsRespons(TaskResult { try await apiClient.fetchOngoingTournaments() }))
                    }
                case .upcommingTournaments:
                    return .run { send in
                        await send(.fetchTournamentsRespons(TaskResult { try await apiClient.fetchUpcomingTournaments() }))
                    }
                }
            case .fetchTournamentsRespons(.success(let series)):
                state.tournaments = series
                state.isFetching = false
                return .none
            case .fetchTournamentsRespons(.failure(let error)):
                state.isFetching = false
                return .none
            }
        
        }
    }
}





struct TournamentListView: View {
    
    var store: StoreOf<TournamentListDomain>
    
    
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
                        ForEach(viewStore.tournaments, id: \.id) { serie in
                            TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: serie), reducer: {
                                TournamentViewCellDomain()
                            }))
                        }
                    }
                }
                .padding(.horizontal)
                .task {
                    viewStore.send(.startedFetching)
                    do {
                        try await Task.sleep(for: .seconds(2))
                    } catch {
                        
                    }
                    viewStore.send(.fetchTournaments)
                }
            }
        }
    }
}

#Preview {
    TournamentListView(
        store: Store(initialState: TournamentListDomain.State(tournaments: [], apiFetchType: .ongoingTournaments), reducer: {
        TournamentListDomain()
    }))
}


//                    if viewStore.isFetching == false {
//                        ForEach(viewStore.tournaments, id: \.id) { serie in
//                            TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: serie), reducer: {
//                                TournamentViewCellDomain()
//                            }))
//                        }
//                    }
