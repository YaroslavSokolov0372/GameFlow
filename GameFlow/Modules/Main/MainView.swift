//
//  MainView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct MainDomain: Reducer {
    
    struct State: Equatable {
          var upomingSeries: [Serie] = []
          var ongoingSeries: [Serie] = []
          var isFetching = true
    }
    
    enum Action {
        
        case fetchOngoingTournaments
        case fetchUpcomingTournaments
        case fetchUpcomingTournamentsResponse(TaskResult<[Serie]>)
        case fetchOngoingTournamentsResponse(TaskResult<[Serie]>)
    }
    
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        
//        BindingReducer()
        
        
        
        Reduce { state, action in
            switch action {
            
            case .fetchOngoingTournaments:
                return .run { send in
                    await send(.fetchOngoingTournamentsResponse(
                        TaskResult {
                            try await apiClient.fetchOngoingTournaments()
                        }
                    ))
                }
            case .fetchUpcomingTournaments:
                return .run { send in
                    await send(.fetchUpcomingTournamentsResponse(
                        TaskResult {
                            try await apiClient.fetchUpcomingTournaments()
                        }
                    ))
                }
            case .fetchUpcomingTournamentsResponse(.failure(let error)):
                return .none
            case .fetchUpcomingTournamentsResponse(.success(let series)):
                state.upomingSeries = series
                return .none
            case .fetchOngoingTournamentsResponse(.success(let series)):
                state.ongoingSeries = series
                return .none
            case .fetchOngoingTournamentsResponse(.failure(let error)):
                return .none
            }
        }
    }
}

struct MainView: View {
    
    var store: StoreOf<MainDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("Ongoing Tournaments")
                        .font(.title2)
                        .bold()
                    
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                    }
                }
                .padding(10)
                
                
                if viewStore.isFetching {
                    
                    
                } else {
                    
                    TournamentsView(store: Store(initialState: TournamentsDomain.State(tournaments: viewStore.ongoingSeries), reducer: {
                        TournamentsDomain()
                    }))
                    TournamentsView(store: Store(initialState: TournamentsDomain.State(tournaments: viewStore.upomingSeries), reducer: {
                        TournamentsDomain()
                    }))
                }
                
                
                
                
                
                Spacer()
            }
            .task {
//                viewStore.send(.fetchOngoingTournaments)
//                viewStore.send(.fetchUpcomingTournaments)
            }
            
        }
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
