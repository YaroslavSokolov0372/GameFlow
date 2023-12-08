//
//  MatchListTabBar.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchListTabBarDomain: Reducer {
    
    struct State: Equatable {
        @BindingState var currentTab: MatchType = .ongoing
        var scrollProgress: CGFloat = .zero
        var tapState: AnimationState = .init()
    }
    
    enum Action {
        case tabSelected(MatchType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let type):
                state.currentTab = type
                return .none
            case .scrollOffsetChanged(let offsetX):
                state.scrollProgress = offsetX
                return .none
            case .animationStateReset:
                state.tapState.reset()
                return .none
            case .animationStateStarted:
                state.tapState.startAnimation()
                return .none
            }
        }
        
    }
}

struct MatchListTabBar: View {
    
    var store: StoreOf<MatchListTabBarDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                ZStack {
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color("Black", bundle: .main))
                            .frame(width: 370, height: 120)
                        
                            .overlay(alignment: .top) {
                                RoundedRectangle(cornerRadius: 0)
                                    .foregroundStyle(Color("Black", bundle: .main))
                                    .frame(width: geo.size.width, height: 60)
                                    .overlay(content: {
                                        
                                        HStack {
                                            ForEach(MatchType.allCases, id: \.self) { type in
                                                Button {
                                                    
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        self.store.send(.tabSelected(type))
                                                        
                                                        self.store.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                        
                                                        self.store.send(.animationStateStarted)

                                                    }
                                                } label: {
                                                    VStack(alignment: .center) {
                                                        Text(type.rawValue)
                                                    }

                                                }
                                                .frame(maxWidth: 113, alignment: .center)
                                                .disabled(viewStore.tapState.status ? true : false)
                                            }
                                        }
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 16))
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .frame(width: 120, height: 50)
                                                .overlay(content: {
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .foregroundStyle(Color("Orange", bundle: .main))
                                                        .blur(radius: 10)
                                                        .opacity(0.6)
                                                })
                                                .offset(x: -120 - (120 * viewStore.scrollProgress))
                                                .offset(x: 60)
                                        )
                                        .modifier(
                                            AnimationEndCallBack(endValaue: viewStore.tapState.progress) {
                                                viewStore.send(.animationStateReset)
    
                                            }
                                        )
                                    })
                            }
                            .offset(y: 40)
                    }
                }
                .frame(width: geo.size.width * 1)
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MatchListTabBar(store: Store(initialState: MatchListTabBarDomain.State(), reducer: {
        MatchListTabBarDomain()
    }))
}
