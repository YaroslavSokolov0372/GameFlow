//
//  MatchesListView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchesListDomain: Reducer {
    
    struct State: Equatable {
        
        var currentTab: MatchType = .ongoing
        
    }
    enum Action {
        
    }
    
    enum MatchType: String, CaseIterable {
        case ongoing = "ONGOING"
        case finished = "FINISHED"
        
        var count: Int {
            return Self.allCases.count - 1
        }
        
        var index: Int {
            return Self.allCases.firstIndex(of: self) ?? 0
        }
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

struct MatchesListView: View {
    
    var store: StoreOf<MatchesListDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                
                ZStack {
                    //MARK: - Header
                    VStack {
                        HStack {
                            
                            Text("TEAM DETAILS")
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
                        
                        TabView {
                            ForEach(0..<2, id: \.self) { num in
                                ScrollView {
                                    VStack(spacing: 15) {
                                        Rectangle()
                                            .frame(width: 370, height: 1)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                        
                                        
                                        ForEach(0..<4, id: \.self) { num in
                                            MatchCellView(store: Store(initialState: MatchCellDomain.State(), reducer: {
                                                MatchCellDomain()
                                            }))
                                            
                                        }
                                        
                                        //MARK: - Rectangle for TaBar not to ovelay on matches when scroll to bottom
                                        Rectangle()
                                            .frame(width: 370, height: 55)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                    }
                                }
                                .scrollIndicators(.never)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea()
                    }
                    
                    
                    VStack() {
                        
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: geo.size.width * 0.95, height: 60)
                            .overlay {
                                HStack {
                                    ForEach(MatchesListDomain.MatchType.allCases, id: \.rawValue) { type in
                                        
                                        Button {
                                            
                                        } label: {
                                            Text(type.rawValue)
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 18))
                                                .frame(width: geo.size.width / 2.2)
                                        }
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundStyle(Color("Orange", bundle: .main))
                                        .frame(width: geo.size.width / 2.12, height: 51)
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .blur(radius: 10)
                                                .opacity(0.6)
                                        })
                                    
                                        .offset(x: -90)
                                )
                            }
                        //                                                    .offset(y: 45)
                    }
                    .frame(width: geo.size.width * 1, height: geo.size.height, alignment: .bottom)
                }
            }
        }
    }
}

#Preview {
    MatchesListView(store: Store(initialState: MatchesListDomain.State(), reducer: {
        MatchesListDomain()
    }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        Color("Black", bundle: .main)
            .ignoresSafeArea()
    )
}

