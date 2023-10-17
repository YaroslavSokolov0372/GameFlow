//
//  DetailInfoView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct DetailInfoDomain: Reducer {
    
    struct State: Equatable {
        let serie: Serie
        var tournaments: [Tournament] = []
        let id: UUID
    }
    
    enum Action {
        case fetchTournaments
        case fetchTournamentsRespons(TaskResult<[Tournament]>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchTournaments:
                return .run { [serie = state.serie] send in
                    await send(.fetchTournamentsRespons(TaskResult { try await apiClient.fetchSeriesTournaments(serie) }))
                }
            case .fetchTournamentsRespons(.success(let tournaments)):
                state.tournaments = tournaments
                print(tournaments)
                return .none
            case .fetchTournamentsRespons(.failure(let error)):
                print(error)
                return .none
            }
        }
    }
}

struct DetailInfoView: View {
    
    var store: StoreOf<DetailInfoDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack {
                
                Color.mainBack
                    .ignoresSafeArea()
                ScrollView {
                    
                    VStack {
                        HStack {
                            Text("Result")
                                .foregroundStyle(.gameListCellForeground)
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            //TODO: - if not finished than this one, then next TODO
                            Image(systemName: "clock")
                                .foregroundStyle(.white)
                                .background(
                                    Circle()
                                        .foregroundStyle(.gray)
                                        .frame(width: 30, height: 30)
                                        
                                )
                            //TODO: - this one
                            Image(systemName: "checkmark")
                                .foregroundStyle(.white)
                                .background(
                                    Circle()
                                        .foregroundStyle(.gray)
                                        .frame(width: 30, height: 30)
                                        
                                )
                            
                            VStack {
                                
                            }
                        }
                        
                        ForEach(viewStore.tournaments, id: \.self) { tournament in
                            
                        }
                    }
                    VStack {
                        //                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        Text("\(viewStore.serie.full_name) \(viewStore.serie.league.name)")
                        
                        VStack {
                            Text("Participants")
                            VStack {
                                ForEach(viewStore.state.tournaments, id: \.self) { tournament in
                                    VStack {
                                        ForEach(tournament.teams, id: \.self) { team in
                                            VStack {
                                                Text(team.acronym ?? team.name)
                                            }
                                        }
                                    }
                                    Text(tournament.name)
                                }
                            }
                        }
                    }
                }
                .task {
                    do {
                        try await Task.sleep(for: .seconds(2))
                        await viewStore.send(.fetchTournaments).finish()
                    } catch { }
                }
            }
        }
    }
}

#Preview {
    DetailInfoView(store: Store(initialState: 
//                                    DetailInfoDomain.State(),
                                    DetailInfoDomain.State(
        serie: Serie(
            begin_at: nil,
            end_at: nil,
            full_name: "",
            id: 123,
            league:
                League(
                    id: 123,
                    image_url: nil,
                    modified_at: "",
                    name: "",
                    slug: "",
                    url: nil),
            league_id: 123,
            modified_at: "fasfsd",
            name: nil,
            season: nil,
            slug: "",
            tournaments: [],
            winner_type: nil,
            year: 123), id: .init()
    ),
                                reducer: {
        DetailInfoDomain()
        
    }))
}
