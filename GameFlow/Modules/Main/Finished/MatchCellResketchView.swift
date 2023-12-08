//
//  MatchCellResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchCellResketchDomain: Reducer {
    
    struct State: Equatable {
        let match: PandascoreMatch
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
        var isStarted = false
    }
    
    enum Action {
        case tick
        case checkTime
        case stopTick
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .stopTick:
                print("stortick")
                return .cancel(id: state.match.id)
            case .checkTime:
                print("check time")
                state.isStarted = state.match.isMatchStarted()
                return .none
            case .tick:
                return .run {
                    send in for await _ in self.clock.timer(interval: .seconds(60)) {
                        await send(.checkTime)
                    }
                }
                .cancellable(id: state.match.id)
            }
        }
    }
}

struct MatchCellResketchView: View {
    
    var store: StoreOf<MatchCellResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            NavigationLink {
                MatchDetailResketchView(store: Store(initialState: MatchDetailResketchDomain.State(isStarted: viewStore.isStarted, match: viewStore.match, liquiTeams: viewStore.liquiTeams), reducer: {
                        MatchDetailResketchDomain()
                })).navigationBarBackButtonHidden()
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color("Gray", bundle: .main))
                        .frame(width: 370, height: 230)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            if viewStore.match.opponents.count >= 1 {
                                let firstLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents.first!.opponent.name)
                                
                                VStack(alignment: .center) {
                                    if firstLiquiTeam != nil {
                                        if firstLiquiTeam!.hasTeamImage {
                                            
                                            AsyncImage(url: URL(string: "https://liquipedia.net/\(firstLiquiTeam!.imageURL)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)
                                            } placeholder: {
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundStyle(Color("Black", bundle: .main))
                                            }
                                            .frame(width: 150, height: 90, alignment: .center)
                                            
                                        } else {
                                            
                                            if viewStore.match.opponents.first!.opponent.image_url != nil {
                                                AsyncImage(url: URL(string:viewStore.match.opponents.first!.opponent.image_url! )) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                } placeholder: {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Black", bundle: .main))
                                                }
                                                .frame(width: 150, height: 90, alignment: .center)
                                                
                                            } else {
                                                VStack {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Black", bundle: .main))
                                                        .overlay(alignment: .center) {
                                                            Text("?")
                                                                .foregroundStyle(.white)
                                                                .font(.gilroy(.medium, size: 30))
                                                        }
                                                    
                                                }
                                                .frame(width: 150, height: 90, alignment: .center)
                                            }
                                        }
                                    } else {
                                        if viewStore.match.opponents.first!.opponent.image_url != nil {
                                            AsyncImage(url: URL(string:viewStore.match.opponents.first!.opponent.image_url! )) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)
                                            } placeholder: {
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundStyle(Color("Black", bundle: .main))
                                                //                                                    .overlay(alignment: .center) {
                                                //                                                        Text("Loading")
                                                //                                                    }
                                            }
                                            .frame(width: 150, height: 90, alignment: .center)
                                        } else {
                                            VStack {
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundStyle(Color("Black", bundle: .main))
                                                    .overlay(alignment: .center) {
                                                        Text("?")
                                                            .foregroundStyle(.white)
                                                            .font(.gilroy(.medium, size: 30))
                                                    }
                                            }
                                            .frame(width: 150, height: 90, alignment: .center)
                                        }
                                    }
                                    
                                    //                                    Text(firstLiquiTeam == nil ? viewStore.match.opponents.first!.opponent.name : firstLiquiTeam!.name.teamFormatted())
                                    Text(firstLiquiTeam == nil ? viewStore.match.opponents[1].opponent.name.teamFormatterName() : firstLiquiTeam!.name.teamFormatterName())
                                        .textCase(.uppercase)
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 12))
                                        .frame(width: 130, height: 30)
                                    //                                        .frame(width: 130, height: 40)
                                    
                                }
                                .frame(width: 150, height: 100, alignment: .center)
                                
                                if viewStore.isStarted {
                                    HStack {
                                        Text("\(viewStore.match.calcScore(of: viewStore.match.opponents.first!.opponent))")
                                        Text(":")
                                        Text("\(viewStore.match.calcScore(of: viewStore.match.opponents[1].opponent))")
                                    }
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.medium, size: 17))
                                    .frame(width: 60)
                                } else if viewStore.match.isMatchFinished() {
                                    
                                    HStack {
                                        Text("\(viewStore.match.calcScore(of: viewStore.match.opponents.first!.opponent))")
                                        Text(":")
                                        Text("\(viewStore.match.calcScore(of: viewStore.match.opponents[1].opponent))")
                                    }
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.medium, size: 17))
                                    .frame(width: 60)
                                    
                            } else {
                                    Text("VS")
                                        .foregroundStyle(.gray)
                                        .font(.gilroy(.bold, size: 17))
                                        .frame(width: 60)
                                }
                                
                                if viewStore.match.opponents.indices.contains(1) {
                                    let secondLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents[1].opponent.name)
                                    
                                    VStack(alignment: .center) {
                                        if secondLiquiTeam != nil {
                                            if secondLiquiTeam!.hasTeamImage {
                                                
                                                AsyncImage(url: URL(string: "https://liquipedia.net/\(secondLiquiTeam!.imageURL)")) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                } placeholder: {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Black", bundle: .main))
                                                }
                                                .frame(width: 150, height: 90, alignment: .center)
                                                
                                            } else {
                                                
                                                if viewStore.match.opponents[1].opponent.image_url != nil {
                                                    AsyncImage(url: URL(string: viewStore.match.opponents[1].opponent.image_url! )) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 80, height: 80)
                                                    } placeholder: {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Black", bundle: .main))
                                                    }
                                                    .frame(width: 150, height: 90, alignment: .center)
                                                    
                                                } else {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Black", bundle: .main))
                                                            .overlay(alignment: .center) {
                                                                Text("?")
                                                                    .foregroundStyle(.white)
                                                                    .font(.gilroy(.medium, size: 30))
                                                            }
                                                        
                                                    }
                                                    .frame(width: 150, height: 90, alignment: .center)
                                                }
                                            }
                                        } else {
                                            if viewStore.match.opponents[1].opponent.image_url != nil {
                                                AsyncImage(url: URL(string: viewStore.match.opponents[1].opponent.image_url! )) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                } placeholder: {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Black", bundle: .main))
                                                }
                                                .frame(width: 150, height: 90, alignment: .center)
                                            } else {
                                                VStack {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Black", bundle: .main))
                                                        .overlay(alignment: .center) {
                                                            Text("?")
                                                                .foregroundStyle(.white)
                                                                .font(.gilroy(.medium, size: 30))
                                                        }
                                                }
                                                .frame(width: 150, height: 90, alignment: .center)
                                            }
                                        }
                                        
                                        Text(secondLiquiTeam == nil ? viewStore.match.opponents[1].opponent.name.teamFormatterName() : secondLiquiTeam!.name.teamFormatterName())
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.bold, size: 12))
                                            .frame(width: 130, height: 30)
                                        
                                    }
                                    .frame(width: 150, height: 100, alignment: .center)
                                } else {
                                    
                                    //IF DIDN'T FIND SECOND OPPONENT
                                    VStack(alignment: .center) {
                                        VStack {
                                            Circle()
                                                .frame(width: 80, height: 80)
                                                .foregroundStyle(Color("Black", bundle: .main))
                                                .overlay(alignment: .center) {
                                                    Text("?")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 30))
                                                }
                                        }
                                        .frame(width: 150, height: 95, alignment: .center)
                                        
                                        Text("TBD")
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.bold, size: 12))
                                            .frame(width: 130, height: 20)
                                    }
                                    .frame(width: 150, height: 100, alignment: .center)
                                    
                                }
                                    
                            } else {
                                //IF HAVEN'T GOT INFO YET
                                VStack(alignment: .center, spacing: 16) {
                                    VStack {
                                        Circle()
                                            .frame(width: 80, height: 80)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                            .overlay(alignment: .center) {
                                                Text("?")
                                                    .foregroundStyle(.white)
                                                    .font(.gilroy(.medium, size: 30))
                                            }
                                    }
                                    
                                    Text("TBD")
                                        .textCase(.uppercase)
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 12))
                                        .frame(width: 130, height: 20)

                                }
                                .frame(width: 150, height: 100, alignment: .center)
                                
                                
                                Text("VS")
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.bold, size: 17))
                                    .frame(width: 60)
                                
                                
                                VStack(alignment: .center, spacing: 16) {
                                    VStack {
                                        Circle()
                                            .frame(width: 80, height: 80)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                            .overlay(alignment: .center) {
                                                Text("?")
                                                    .foregroundStyle(.white)
                                                    .font(.gilroy(.medium, size: 30))
                                            }
                                    }
                                    
                                    Text("TBD")
                                        .textCase(.uppercase)
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 12))
                                        .frame(width: 130, height: 20)

                                }
                                .frame(width: 150, height: 100, alignment: .center)
                            }
                        }
                        .padding(.bottom, 24)
                        
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundStyle(.gray)
                        
                        HStack() {
                            Text(viewStore.match.matchTime())
                                .font(.gilroy(.medium, size: 16))
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text("Live")
                                .foregroundStyle(.white)
                                .font(.gilroy(.medium, size: 16))
                                .padding(4)
                                .padding(.horizontal, 3)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .foregroundStyle(Color("Orange", bundle: .main))
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .blur(radius: 10)
                                                .opacity(0.5)
                                        })
                                )
                                .opacity(viewStore.isStarted == true ? 1 : 0)
                                .animation(.easeInOut(duration: 0.1), value: viewStore.isStarted)

                        }
                        .padding()
                        .frame(height: 60)

                        
                    }
                    .frame(width: 360, height: 230, alignment: .bottom)
                }
                .task({
                  try? await Task.sleep(for: .seconds(5))
                    self.store.send(.tick)
                    print("tick started")
                })
                .onDisappear {
                    self.store.send(.stopTick)
                }
            }
        }
    }
}

//
//#Preview {
//    MatchCellResketchView(store: Store(initialState: MatchCellResketchDomain.State(match: PandascoreMatch(begin_at: "2023-11-13T14:20:44Z", detailed_stats: true, draw: false, end_at: "2023-11-13T14:50:32Z", forfeit: false, game_advantage: nil, games: [PandascoreGame(begin_at: "2023-11-13T14:20:44Z", complete: true, detailed_stats: true, end_at: "2023-11-13T14:20:59Z", finished: true, forfeit: true, length: 14, match_id: 871729, position: 1, status: "finished", winner: PandascoreGameWinner(id: 133873, type: "")), PandascoreGame(begin_at: "2023-11-13T14:21:01Z", complete: false, detailed_stats: true, end_at: "2023-11-13T14:50:33Z", finished: true, forfeit: false, length: 1771, match_id: 871729, position: 2, status: "finished", winner: PandascoreGameWinner(id: 133873, type: "Team"))], id: 871729, modified_at: "2023-11-13T15:25:36Z", name: "Semifinal 1: Klim Sani4 vs YeS", number_of_games: 3, opponents: [PandascoreOpponents(opponent: Opponent(acronym: "KS", id: 133873, image_url: nil, locatioin: nil, modified_at: "2023-11-26T11:08:52Z", name: "Klim Sani4", slug: "klim-sani4"), type: "Team"), PandascoreOpponents(opponent: Opponent(acronym: "YeS", id: 1931, image_url: "", locatioin: "", modified_at: "2023-11-25T17:27:39Z", name: "Yellow Submarine", slug: "Yellow Submarine"), type: "Team")], original_scheduled_at: "2023-11-13T13:00:00Z", rescheduled: true, results: [PandascoreResult(score: 2, team_id: 133873), PandascoreResult(score: 0, team_id: 1931)], scheduled_at: "2023-11-13T13:55:00Z", serie_id: 6890, slug: "klim-sani4-vs-yellow-submarine-2023-11-13", status: "finished")), reducer: {
//        MatchCellResketchDomain()
//    }))
//}
