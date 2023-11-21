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
    }
    
    enum Action: BindableAction {
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

struct DetailInfoResketchView: View {
    
    @Environment(\.dismiss) var dismiss
    var store: StoreOf<DetailInfoResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                
                GeometryReader { geo in
                    ZStack {
                        Color("Black", bundle: .main)
                            .ignoresSafeArea()
                        
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
                                            
                                            VStack(spacing: 25) {
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Matches")
                                                            .frame(width: geo.size.width / 3)
                                                            .font(.gilroy(.bold, size: 18))
                                                        
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()

                                                        NavigationLink {
                                                            MatchesListView(store: Store(initialState: MatchesListDomain.State(), reducer: {
                                                                MatchesListDomain()
                                                            })).navigationBarBackButtonHidden()
//                                                            
                                                        } label: {
                                                            
                                                            Image("Arrow", bundle: .main)
                                                                .resizable()
                                                                .renderingMode(.template)
                                                                .frame(width: 30, height: 25)
                                                                .foregroundStyle(.white)
                                                                .padding(.trailing, 20)
   
                                                        }
                                                        
                                                        
                                                        
                                                        //                                                    Button {
                                                        //
                                                        //                                                        self.store.send(.matchListTapped)
                                                        //                                                    } label: {
                                                        //                                                        Image("Arrow", bundle: .main)
                                                        //                                                            .resizable()
                                                        //                                                            .renderingMode(.template)
                                                        //                                                            .frame(width: 30, height: 25)
                                                        //                                                            .foregroundStyle(.white)
                                                        //                                                            .padding(.trailing, 20)
                                                        //                                                    }
                                                    }
                                                    .frame(height: 35)
                                                    
                                                    
                                                    OngoingMatchListView(store: Store(initialState: OngoingMatchListDomain.State(), reducer: {
                                                        OngoingMatchListDomain()
                                                    }))
                                                }
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Standings")
                                                            .frame(width: geo.size.width / 3)
                                                            .font(.gilroy(.bold, size: 18))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(height: 30)
                                                    
                                                    StandingsView(store: Store(initialState: StandingsDomain.State(), reducer: {
                                                        StandingsDomain()
                                                    }))
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
                                                    
                                                    PartisipantsResketchView(store: Store(initialState: PartisipantsResketchDomain.State(teams: viewStore.serie.sortedTournamentsByBegin[num].teams), reducer: {
                                                        PartisipantsResketchDomain()
                                                    }))
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
                                                
                                                switch viewStore.serie.sortedTournamentsByBegin[num].tournament.name {
                                                    
                                                case "Group Stage":
                                                    Text("Group Stage")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                    
                                                case "Playoffs":
                                                    Text("Playoffs")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                default:
                                                    Text("Phase \(num)")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                }
                                                
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
