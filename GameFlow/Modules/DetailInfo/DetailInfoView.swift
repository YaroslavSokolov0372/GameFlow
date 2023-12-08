//
//  DetailInfoView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DetailInfoDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var currentTab = 0
        var serie: Serie
        
    }
    
    enum Action: BindableAction {
        case showBracketsTapped
        case binding(BindingAction<State>)
        case tabSelected(Int)
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.currentTab = tab
                return .none
                
            default: return .none
            }
        }
        BindingReducer()
    }
}

struct DetailInfoView: View {
    
    @Environment(\.dismiss) private  var dismiss
    var store: StoreOf<DetailInfoDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            GeometryReader { geo in
                ZStack {
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        
                        HeaderView(width: geo.size.width, header: viewStore.serie.serie.league.name)
                        
                        TabView(selection: viewStore.binding(get: \.currentTab, send: { .tabSelected($0) } )) {
                            ForEach(viewStore.serie.sortedTournamentsByBegin.indices, id: \.self) { num in
                                ScrollView {
                                    
                                    VStack(spacing: 10) {
                                        
                                        VStack {
                                            HStack {
                                                Text("Matches")
                                                    .frame(width: geo.size.width / 3)
                                                    .font(.gilroy(.bold, size: 18))
                                                
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                                NavigationLink {
                                                    MatchesListView(store: Store(
                                                        initialState:  MatchesListDomain.State(
                                                            liquiInfo: viewStore.serie.liquipediaSerie!.teams,
                                                            tournament: viewStore.serie.tournaments.sortedTournamentsByBegin[num]
                                                        ), reducer: {
                                                            MatchesListDomain()
                                                        })).navigationBarBackButtonHidden()
                                                    
                                                } label: {
                                                    
                                                    Image("Arrow", bundle: .main)
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 17)
                                                        .foregroundStyle(.white)
                                                        .padding(.trailing, 20)
                                                    
                                                }
                                            }
                                            .frame(width: geo.size.width, height: 35)
                                            
                                            
                                            OngoingMatchListView(store: Store(
                                                initialState: OngoingMatchListDomain.State(
                                                    matches: viewStore.serie.tournaments.sortedTournamentsByBegin[num].matches!.upciming,
                                                    liquiInfo: viewStore.serie.liquipediaSerie!.teams),
                                                reducer: { OngoingMatchListDomain() }))
                                        }
                                        
                                        VStack {
                                            if viewStore.serie.tournaments.sortedTournamentsByBegin[num].tournament.name != "Playoffs" {
                                                HStack {
                                                    Text("Standings")
                                                        .frame(width: geo.size.width / 3)
                                                        .font(.gilroy(.bold, size: 18))
                                                        .foregroundStyle(.white)
                                                    
                                                    Spacer()
                                                }
                                                .frame(height: 30)
                                                
                                                StandingsView(store: Store(
                                                    initialState: StandingsDomain.State(
                                                        liquiTeams: viewStore.serie.liquipediaSerie!.teams,
                                                        standings: viewStore.serie.tournaments.sortedTournamentsByBegin[num].standings!,
                                                        newStandings: viewStore.serie.tournaments.sortedTournamentsByBegin[num].matches!.getStandings(
                                                            liquiInfo: viewStore.serie.liquipediaSerie! , tournament: viewStore.serie.tournaments.sortedTournamentsByBegin[num])
                                                    ), reducer: {
                                                        StandingsDomain()
                                                    }))
                                                
                                            } else {
                                                HStack {
                                                    Text("Brackets")
                                                        .frame(width: geo.size.width / 3)
                                                        .font(.gilroy(.bold, size: 18))
                                                        .foregroundStyle(.white)
                                                    
                                                    Spacer()
                                                    
                                                }
                                                .frame(height: 30)
                                                
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(Color("Gray", bundle: .main))
                                                    .frame(width: geo.size.width * 0.94, height: geo.size.height * 0.25)
                                                    .overlay {
                                                        NavigationLink {
                                                            BracketsResketchView(store: Store(
                                                                initialState: BracketsResketchDomain.State(
                                                                    brackets: viewStore.serie.tournaments.sortedTournamentsByBegin[num].brackets!
                                                                ), reducer: {
                                                                    BracketsResketchDomain()
                                                                })).navigationBarBackButtonHidden()
                                                        } label: {
                                                            Text("Press to see the Brackets")
                                                                .foregroundStyle(.white)
                                                                .font(.gilroy(.medium, size: 18))
                                                        }
                                                    }
                                            }
                                        }
                                        
                                        VStack {
                                            HStack {
                                                Text("Partisipants")
                                                    .frame(width: geo.size.width / 3)
                                                    .font(.gilroy(.bold, size: 18))
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                            }
                                            .frame(height: 30)
                                            .padding(.horizontal, 13)

                                            PartisipantsListView(store: Store(
                                                initialState: PartisipantsListDomain.State(
                                                    teams: viewStore.serie.tournaments.sortedTournamentsByBegin[num].teams,
                                                    liquiTeams: viewStore.serie.liquipediaSerie!.getTournamentTeams(viewStore.serie.tournaments.sortedTournamentsByBegin[num])),
                                                reducer: { PartisipantsListDomain() }))
                                            
                                            .padding(.bottom, 7)
                                        }
                                    }
                                    .padding(.vertical, 10)
                                }
                                .background(
                                    Color("Black", bundle: .main)
                                )
                                .contentShape(Rectangle()).gesture(DragGesture())
                                .scrollIndicators(.never)
                                .tag(num)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea()
                        
                        //MARK: - TabViewItems

                            ScrollView(.horizontal) {
                                
                                HStack(spacing: 0) {
                                    ForEach(viewStore.serie.sortedTournamentsByBegin.indices, id: \.self) { num in
                                        VStack {
                                            Button {
                                                viewStore.send(.tabSelected(num))
                                                
                                            } label: {
                                                
                                                Text(viewStore.serie.sortedTournamentsByBegin[num].tournament.name.uppercased())
                                                    .foregroundStyle(.white)
                                                    .font(.gilroy(.medium, size: 16))
                                            }
                                            .padding(.bottom, 7)
                                            
                                            Rectangle()
                                                .frame(height: 2)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .opacity(viewStore.currentTab == num ? 1 : 0)
                                        }
                                        
                                        .frame(width:
                                                viewStore.serie.tournaments.count == 2 ? geo.size.width / 2 :
                                                viewStore.serie.tournaments.count == 1 ? geo.size.width / 1 :
                                                geo.size.width / 3)
                                        .frame(maxHeight: 50, alignment: .bottom)
                                        .overlay {
                                            Rectangle()
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .opacity(0.3)
                                                .mask {
                                                    LinearGradient(colors: [
                                                        .white,
                                                        .white.opacity(0.3),
                                                        .white.opacity(0.2),
                                                        .white.opacity(0.1)
                                                    ], startPoint: .bottom, endPoint: .top)
                                                }
                                                .opacity(viewStore.currentTab == num ? 1 : 0)
                                        }
                                    }
                                }
                                .animation(.easeInOut(duration: 0.3), value: viewStore.currentTab)
                            }
                            .scrollIndicators(.never)
                            .padding(.bottom, 24)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}

//#Preview {
//    DetailInfoView(store: Store(initialState: DetailInfoDomain.State(), reducer: {
//        DetailInfoDomain()
//    }))
//    .preferredColorScheme(.dark)
//    .background {
//        Color("Black", bundle: .main)
//    }
//}
//
