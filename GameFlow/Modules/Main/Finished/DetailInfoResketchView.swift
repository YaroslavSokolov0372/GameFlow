//
//  DetailInfoResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture


struct DetailInfoResketchDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var currentTab = 0
        var serie: Serie
        
//        var showBrackets = false
//        var bracketsState = BracketsResketchDomain.State()
    }
    
    enum Action: BindableAction {
        case showBracketsTapped
        case binding(BindingAction<State>)
        case tabSelected(Int)
//        case bracketsAction(BracketsResketchDomain.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        
//        Scope(state: \.bracketsState, action: /Action.bracketsAction) {
//            BracketsResketchDomain()
//        }
        
        Reduce { state, action in
            switch action {
//            case .bracketsAction(.shouldClose):
//                state.showBrackets = false
//                return .run { send in
////                    await send(.bracketsAction(.unblurView))
//                }
//            case .showBracketsTapped:
//                state.showBrackets = true
//                return .run { send in
//                    await send(.bracketsAction(.unblurView))
//                }
            case .tabSelected(let tab):
                state.currentTab = tab
                return .none
                
            default: return .none
            }
        }
        BindingReducer()
    }
}

struct DetailInfoResketchView: View {
    
    @Namespace private var animation
    @Environment(\.dismiss) private  var dismiss
    var store: StoreOf<DetailInfoResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            GeometryReader { geo in
                ZStack {
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
//                    if !viewStore.showBrackets {
                    VStack(spacing: 0) {
                        
                        //MARK: - Header
                        HStack {
                            
                            Text(viewStore.serie.serie.league.name)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 18))
                                .frame(width: geo.size.width, alignment: .center)
                        }
                        .overlay {
                            HStack {
                                Button {
                                    
                                    dismiss()
                                    
                                } label: {
                                    Image("Arrow", bundle: .main)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .rotationEffect(.degrees(180))
                                        .frame(width: 30, height: 25)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.vertical, 15)
                        .padding(.bottom, 5)
                        
                        
                        
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
                                                    MatchesListReskatchView(store: Store(
                                                        initialState: MatchesListResketchDomain.State(
                                                            liquiInfo: viewStore.serie.liquipediaSerie!.teams,
                                                            tournament: viewStore.serie.tournaments[num]
                                                        ), reducer: {
                                                            MatchesListResketchDomain()
                                                        })).navigationBarBackButtonHidden()
                                                    
                                                } label: {
                                                    
                                                    Image("Arrow", bundle: .main)
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 30, height: 25)
                                                        .foregroundStyle(.white)
                                                        .padding(.trailing, 20)
                                                    
                                                }
                                            }
                                            .frame(width: geo.size.width, height: 35)
                                            
                                            
                                            OngoingMatchListViewResketch(store: Store(
                                                initialState: OngoingMatchListResketchDomain.State(
                                                    matches: viewStore.serie.tournaments[num].matches!.upciming,
                                                    liquiInfo: viewStore.serie.liquipediaSerie!.teams),
                                                reducer: { OngoingMatchListResketchDomain() }))
                                        }
                                        
                                        VStack {
                                            if viewStore.serie.tournaments[num].tournament.name != "Playoffs" {
                                                HStack {
                                                    Text("Standings")
                                                        .frame(width: geo.size.width / 3)
                                                        .font(.gilroy(.bold, size: 18))
                                                        .foregroundStyle(.white)
                                                    
                                                    Spacer()
                                                }
                                                .frame(height: 30)
                                                
                                                StandingsResketch(store: Store(
                                                    initialState: StandingsResketchDomain.State(
                                                        liquiTeams: viewStore.serie.liquipediaSerie!.teams,
                                                        standings: viewStore.serie.tournaments[num].standings!,
                                                        newStandings: viewStore.serie.tournaments[num].matches!.getStandings(
                                                            liquiInfo: viewStore.serie.liquipediaSerie! , tournament: viewStore.serie.tournaments[num])
                                                    ), reducer: {
                                                        StandingsResketchDomain()
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
                                                
                                                
                                                //                                                    BracketsResketchView(store: self.store.scope(state: \.bracketsState, action: DetailInfoResketchDomain.Action.bracketsAction))
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(Color("Gray", bundle: .main))
                                                    .frame(width: geo.size.width * 0.94, height: geo.size.height * 0.25)
                                                //                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                    .overlay {
                                                        NavigationLink {
                                                            //                                                            BracketsResketchView(store: self.store.scope(state: \.bracketsState, action: DetailInfoResketchDomain.Action.bracketsAction)).navigationBarBackButtonHidden()
                                                            BracketsResketchView(store: Store(
                                                                initialState: BracketsResketchDomain.State(
                                                                    brackets: viewStore.serie.tournaments[num].brackets!
//                                                                        .upperBrackets
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
                                            
                                            PartisipantsResketchView(store: Store(
                                                initialState: PartisipantsResketchDomain.State(
                                                    teams: viewStore.serie.tournaments[num].teams,
                                                    liquiTeams: viewStore.serie.liquipediaSerie!.getTournamentTeams(viewStore.serie.tournaments[num])),
                                                reducer: { PartisipantsResketchDomain() }))
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
                    }
                }
            }
        }
    }
}

//#Preview {
//    DetailInfoResketchView(store: Store(initialState: DetailInfoResketchDomain.State(), reducer: {
//        DetailInfoResketchDomain()
//    }))
//}


//let regex = "\\[[^\\]]*\\]"
