//
//  UpcomingMatchCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct UpcomingMatchDomain: Reducer  {
    struct State: Equatable {
        var opponents: [OpponentClass] = []
        let match: Match
        let matchesTournament: String
    }
    enum Action {
        case fetchOponents
        case fetchOponentsResponse(TaskResult<[OpponentClass]>)
    }
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchOponents:
                return .run { [match = state.match] send in
                    await send(.fetchOponentsResponse(TaskResult { try await apiClient.fetchTeamsForUpcomingGame(match) }))
                }
            case .fetchOponentsResponse(.success(let oponents)):
                state.opponents = oponents
                return .none
            case .fetchOponentsResponse(.failure(let error)):
                return .none
            }
        }
    }
}

struct UpcomingMatchCell: View {
    
    var store: StoreOf<UpcomingMatchDomain>
    
    
    var body: some View {
        
        
        WithViewStore(store, observe: { $0 }) { viewStore in
             
            VStack {
                Text(viewStore.matchesTournament)
                    .foregroundStyle(.white)
                    .font(.callout)
                    .bold()
                HStack {
                    Text(viewStore.match.begin_at!)
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .bold()
                }
                
                HStack {
                    ForEach(viewStore.opponents, id: \.self) { opponent in
                        HStack {
                            AsyncImage(url: URL(string: opponent.opponent.image_url ?? "")) { phase in
                                if let image = phase.image {
                                    VStack(spacing: 12) {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .padding(.horizontal, 10)
                                        Text(opponent.opponent.name)
                                            .foregroundStyle(.white)
                                            .bold()
                                            .font(.system(size: 15))
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .overlay {
                    Text("-")
                        .foregroundStyle(.white)
                }
            }
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white)
                    })
            )
            
            .task {
                viewStore.send(.fetchOponents)
            }
        }
        
    }
}

#Preview {

   
    
    
    DetailInfoView(store: Store(initialState:
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
            year: 123), id: .init(), teams: [Team(acronym: "EG", id: 123, image_url: "https://cdn.pandascore.co/images/team/image/1653/152px_evil_geniuses_2020_lightmode.png", location: "US", modified_at: "2023-10-16T06:07:24Z", name: "Evil Geniuses", slug: "evil-geniuses-dota-2"), Team(acronym: "LGD", id: 123, image_url: "https://cdn.pandascore.co/images/team/image/1657/600px_lgd_gaming_december_2019_lightmode.png", location: "CN", modified_at: "2023-10-16T06:07:24Z", name: "LGD Gaming", slug: "evil-geniuses-dota-2")]), reducer: {
        DetailInfoDomain()
        
    }))
}
