//
//  MatchesListReskatchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchesListResketchDomain: Reducer{
    
    
    struct State: Equatable {
        
        let liquiInfo: [LiquipediaSerie.LiquipediaTeam]
        let tournament: Tournament
        @BindingState var currentTab: MatchType = .ongoing
        var scrollProgress: CGFloat = .zero
        var tapState: AnimationState = .init()
        var tabBarState = MatchListTabBarDomain.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(MatchType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset
        case tabBarAction(MatchListTabBarDomain.Action)
    }
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.tabBarState, action: /Action.tabBarAction) {
            MatchListTabBarDomain()
        }
        
        Reduce { state, action in
            switch action {
                
            case .tabBarAction(.scrollOffsetChanged(let offsetX)):
                state.scrollProgress = offsetX
                return .none
            case .tabBarAction(.tabSelected(let type)):
                state.currentTab = type
                return .none
            case .tabBarAction(.animationStateStarted):
                state.tapState.startAnimation()
                return .none
            case .tabBarAction(.animationStateReset):
                state.tapState.reset()
                return .none
                
                

            case .tabSelected(let type):
                state.currentTab = type
                state.tabBarState.currentTab = type
                return .none
            case .scrollOffsetChanged(let offsetX):
                state.scrollProgress = offsetX
                state.tabBarState.scrollProgress = offsetX
                return .none
            case .animationStateReset:
                state.tapState.reset()
                state.tabBarState.tapState.reset()
                return .none
            case .animationStateStarted:
                state.tapState.startAnimation()
                state.tabBarState.tapState.startAnimation()
                return .none
                
            default: return .none
            }
        }
        BindingReducer()
    }
}

struct MatchesListReskatchView: View {
    
    @Environment(\.dismiss) var dismiss
    var store: StoreOf<MatchesListResketchDomain>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                
                ZStack {
                    
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack {
                        //MARK: - Header
                        HStack {
                            
                            Text("MATCH LIST")
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
                        
//                        TabView(selection: viewStore.binding(get: \.currentTab, send: { .tabSelected($0) })) {
                        TabView(selection: viewStore.$currentTab) {
                            ForEach(MatchType.allCases, id: \.self) { type in
                                ScrollView {
                                    VStack(spacing: 15) {
                                        Rectangle()
                                            .frame(width: 370, height: 1)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                        
                                        switch type {
                                        case .finished:
                                            if viewStore.tournament.matches!.finished.isEmpty {
                                                
                                                Text("There are no Matches in this section")
                                                    .foregroundStyle(.white)
                                                    .font(.gilroy(.medium, size: 20))
                                                
                                            } else {
                                                ForEach(viewStore.tournament.matches!.finished, id: \.self) { match in
                                                    MatchCellResketchView(store: Store(initialState: MatchCellResketchDomain.State(match: match, liquiTeams: viewStore.liquiInfo), reducer: {
                                                        MatchCellResketchDomain()
                                                    }))
                                                }
                                            }
                                        case .ongoing:
                                            if viewStore.tournament.matches!.upciming.isEmpty {
                                                
                                                Text("There are no Matches in this section")
                                                    .foregroundStyle(.white)
                                                    .font(.gilroy(.medium, size: 20))
                                                
                                            } else {
                                                ForEach(viewStore.tournament.matches!.upciming, id: \.self) { match in
                                                    MatchCellResketchView(store: Store(initialState: MatchCellResketchDomain.State(match: match, liquiTeams: viewStore.liquiInfo, isStarted: match.isMatchStarted()), reducer: {
                                                        MatchCellResketchDomain()
                                                    }))
                                                }
                                            }
                                        }
                                        
                                        //MARK: - Rectangle for TaBar not to ovelay on matches when scroll to bottom
                                        Rectangle()
                                            .frame(width: 370, height: 40)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                    }
                                }
                                .tag(type)
                                .scrollIndicators(.never)
                                .offsetX(type == viewStore.currentTab) { size in
                                    
                                    let minX = size.minX
                                    let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                    let pageProgress = pageOffset / geo.size.width
                                    
                                    
                                    let limitation = max(min(pageProgress, 0), -CGFloat(MatchesListDomain.MatchType.allCases.count - 1))
                                    if !viewStore.tapState.status {
                                        viewStore.send(.scrollOffsetChanged(limitation))
                                    }
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea()
                    }
                    .overlay {
                        MatchListTabBar(store: self.store.scope(state: \.tabBarState, action: MatchesListResketchDomain.Action.tabBarAction))
                    }
                    
                    
//                    VStack() {
//                        
//                        RoundedRectangle(cornerRadius: 30)
//                            .foregroundStyle(Color("Black", bundle: .main))
//                            .frame(width: geo.size.width * 0.95, height: 60)
//                            .overlay {
//                                HStack {
//                                    ForEach(MatchType.allCases, id: \.rawValue) { type in
//                                        Button {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                self.store.send(.tabSelected(type))
//                                                
//                                                self.store.send(.scrollOffsetChanged(-CGFloat(type.index)))
//                                                
//                                                self.store.send(.animationStateStarted)
//                                                
//                                            }
//                                        } label: {
//                                            Text(type.rawValue)
//                                                .foregroundStyle(.white)
//                                                .font(.gilroy(.bold, size: 17))
//                                                .frame(width: geo.size.width / 2.2)
//                                        }
//                                        .disabled(viewStore.tapState.status ? true : false)
//                                    }
//                                }
//                                .background(
//                                    RoundedRectangle(cornerRadius: 25)
//                                        .foregroundStyle(Color("Orange", bundle: .main))
//                                        .frame(width: geo.size.width / 2.12, height: 50)
//                                        .overlay(content: {
//                                            RoundedRectangle(cornerRadius: 25)
//                                                .foregroundStyle(Color("Orange", bundle: .main))
//                                                .blur(radius: 10)
//                                                .opacity(0.6)
//                                        })
//                                        .offset(x: -90 - (180 * viewStore.scrollProgress))
//                                )
//                                .modifier(
//                                    AnimationEndCallBack(endValaue: viewStore.tapState.progress) {
//                                        viewStore.send(.animationStateReset)
//                                    }
//                                )
//                            }
//                    }
//                    .frame(width: geo.size.width * 1, height: geo.size.height, alignment: .bottom)
                }
            }
        }
    }
}

//#Preview {
//    MatchesListReskatchView(store: Store(initialState: MatchesListResketchDomain.State(), reducer: {
//        MatchesListResketchDomain()
//    }))
//}
