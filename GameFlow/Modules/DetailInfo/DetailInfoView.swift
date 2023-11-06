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

struct DetailInfoView: View {
    
    var store: StoreOf<DetailInfoDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            GeometryReader { geo in
                ZStack {
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        
                        //MARK: - Header
                        HStack {
                            
                            Text("The International")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 18))
                                .frame(width: geo.size.width, alignment: .center)
                        }
                        .overlay {
                            HStack {
                                Button {
                                    
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
                        
                        
                        
                        TabView {
                            ForEach(0..<4, id: \.self) { num in
                                ScrollView {
                                    VStack(spacing: 25) {
                                        
                                        
                                        VStack {
                                            HStack {
                                                Text("Matches")
                                                    .frame(width: geo.size.width / 3)
                                                    .font(.gilroy(.bold, size: 18))

                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                            }
                                            .frame(height: 30)
                                            
                                            MatchListView(store: Store(initialState: MatchListDomain.State(), reducer: {
                                                MatchListDomain()
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
                                            
                                            PartisipantsListView(store: Store(initialState: PartisipantsListDomain.State(), reducer: {
                                                PartisipantsListDomain()
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
                                
                            }
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea()
                        
                        
                        //MARK: - TabViewItems
                        ScrollView(.horizontal) {
                            
                            HStack(spacing: 0) {
                                ForEach(0..<4, id: \.self) { num in
                                    VStack {
                                        Button {
                                            
                                        } label: {
                                            Text("Group \(num)")
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.medium, size: 16))
                                        }
                                        .padding(.bottom, 7)
                                        
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundStyle(Color("Orange", bundle: .main))
                                            .opacity(viewStore.currentTab == num ? 1 : 0)
                                    }
                                    .frame(width: geo.size.width / 3)
                                    .frame(maxHeight: 50, alignment: .bottom)
                                    .overlay {
                                        Rectangle()
                                            .foregroundStyle(Color("Orange", bundle: .main))
                                            .opacity(0.3)
                                            .mask {
                                                LinearGradient(colors: [.white, .white.opacity(0.3), .white.opacity(0.2), .white.opacity(0.1)], startPoint: .bottom, endPoint: .top)
                                            }
                                            .opacity(viewStore.currentTab == num ? 1 : 0)
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.never)
                    }
                }
            }
        }
    }
}

#Preview {
    DetailInfoView(store: Store(initialState: DetailInfoDomain.State(), reducer: {
        DetailInfoDomain()
    }))
    .background {
        Color("Black", bundle: .main)
    }
}
