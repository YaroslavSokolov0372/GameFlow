//
//  Home.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct Search: Reducer {
    
    struct State: Equatable {
        @BindingState var searchQuery = ""
        var gameList: [Game] = []
        var listOfGames: IdentifiedArrayOf<GameDomain.State> = []
    }
    
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case cancelSearchTapped
        case fetchGameListResponse(TaskResult<[Game]>)
        case fetchAllGames
        case game(id: GameDomain.State.ID, action: GameDomain.Action)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        
//        forEach(\.listOfGames, action: /Action.game(id:, action:)) {
//            
//        }
        
        Reduce { state, action in
            
            switch action {
            case .cancelSearchTapped:
                print("tapped search cancel button")
                return .none
            case .binding(_):
                return .none
            case .binding(\.$searchQuery):
                return .none

                
                
                
                
            case .fetchAllGames:
                return .run { send in
                    await send(.fetchGameListResponse(TaskResult {
                        try await self.apiClient.fetchGamges() } ))}
                
            case .fetchGameListResponse(.failure(let error)):
                print(error)
                return .none
            case .fetchGameListResponse(.success(let games)):
                state.gameList = games
                
                state.listOfGames = .init(uniqueElements: games.map({
                    GameDomain.State(id: UUID(), game: $0)
                }))
                
                print(games)
                return .none
                
            }
        }
        .forEach(\.listOfGames, action: /Action.game(id:action:)) {
            GameDomain()
        }
    }
}

struct GameList: View {
    
    var store: StoreOf<Search>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.mainBack
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEachStore(self.store.scope(
                                state: \.listOfGames,
                                action: { .game(id: $0, action: $1)})) { gameStore in
                                GameCell(store: gameStore)
                                
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .task {
//                    viewStore.send(.fetchAllGames)
                }
            }
        }
    }
}

#Preview {
    GameList(store: Store(initialState: Search.State(), reducer: {
        Search()
    }))
}
