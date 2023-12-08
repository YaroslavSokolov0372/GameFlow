//
//  MatchCellView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchCellDomain: Reducer {
    
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
                return .cancel(id: state.match.id)
            case .checkTime:
                if state.match.status != "finished" {
                    state.isStarted = state.match.isMatchStarted()
                }
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

struct MatchCellView: View {
    var store: StoreOf<MatchCellDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            NavigationLink {

                MatchDetailView(store: Store(initialState: MatchDetailDomain.State(isStarted: viewStore.isStarted, match: viewStore.match, liquiTeams: viewStore.liquiTeams), reducer: {
                    MatchDetailDomain()
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
                                    
                                
                                    Text(firstLiquiTeam == nil ? viewStore.match.opponents[1].opponent.name.teamFormatterName() : firstLiquiTeam!.name.teamFormatterName())
                                        .textCase(.uppercase)
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 12))
                                        .frame(width: 130, height: 30)
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
                    if viewStore.match.status != "finished" {
                        self.store.send(.tick)
                        print("tick started")
                    }
                })
                .onDisappear {
                    self.store.send(.stopTick)
                }
            }
        }
    }
}

//#Preview {
//    MatchCellView(store: Store(initialState: MatchCellDomain.State(), reducer: {
//        MatchCellDomain()
//    }))
//}
