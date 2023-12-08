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
    
//    enum MatchType: String, CaseIterable {
//        case ongoing = "ONGOING"
//        case finished = "FINISHED"
//        
//        var count: Int {
//            return Self.allCases.count - 1
//        }
//        
//        var index: Int {
//            return Self.allCases.firstIndex(of: self) ?? 0
//        }
//    }
    
    
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

struct MatchesListView: View {
    
    @Environment(\.dismiss) var dismiss
    var store: StoreOf<MatchesListDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                
                ZStack {
                    
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack {
                        //MARK: - Header
                        
                        HeaderView(width: geo.size.width, header: "Match List")
                        
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
                                                    MatchCellView(store: Store(initialState: MatchCellDomain.State(match: match, liquiTeams: viewStore.liquiInfo), reducer: {
                                                        MatchCellDomain()
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
                                                    MatchCellView(store: Store(initialState: MatchCellDomain.State(match: match, liquiTeams: viewStore.liquiInfo), reducer: {
                                                        MatchCellDomain()
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
                                    
                                    let limitation = max(min(pageProgress, 0), -CGFloat(MatchType.allCases.count - 1))
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
                        MatchListTabBar(store: self.store.scope(state: \.tabBarState, action: MatchesListDomain.Action.tabBarAction))
                    }
                }
            }
        }
    }
}

//#Preview {
//    MatchesListView(store: Store(initialState: MatchesListDomain.State(), reducer: {
//        MatchesListDomain()
//    }))
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(
//        Color("Black", bundle: .main)
//            .ignoresSafeArea()
//    )
//}
//
