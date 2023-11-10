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
        @BindingState var scrollProgress: CGFloat = .zero
        @BindingState var currentTab: MatchType = .ongoing
        @BindingState var tapState: AnimationState = .init()
    }
    
    enum Action {
        case tabChanged(MatchType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset

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
            case .animationStateReset:
                state.tapState.reset()
                return .none
            case .animationStateStarted:
                state.tapState.startAnimation()
                return .none
            case .scrollOffsetChanged(let offset):
                state.scrollProgress = offset
                return .none
            case .tabChanged(let tab):
                state.currentTab = tab
                return .none
            }
        }
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
                    
                    //MARK: - Header
                    VStack {
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
                        
                        TabView(selection: viewStore.binding(get: \.currentTab, send: { .tabChanged($0) })) {
                            ForEach(MatchesListDomain.MatchType.allCases, id: \.self) { type in
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
                                    .tag(type)
                                }
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
                    
                    
                    VStack() {
                        
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color("Black", bundle: .main))
                            .frame(width: geo.size.width * 0.95, height: 60)
                            .overlay {
                                HStack {
                                    ForEach(MatchesListDomain.MatchType.allCases, id: \.rawValue) { type in
                                        Button {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                self.store.send(.tabChanged(type))
                                                
                                                self.store.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                
                                                self.store.send(.animationStateStarted)
                                                
                                            }
                                        } label: {
                                            Text(type.rawValue)
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 17))
                                                .frame(width: geo.size.width / 2.2)
                                        }
                                        .disabled(viewStore.tapState.status ? true : false)
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundStyle(Color("Orange", bundle: .main))
                                        .frame(width: geo.size.width / 2.12, height: 50)
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .blur(radius: 10)
                                                .opacity(0.6)
                                        })
                                        .offset(x: -90 - (180 * viewStore.scrollProgress))
                                )
                                .modifier(
                                    AnimationEndCallBack(endValaue: viewStore.tapState.progress) {
                                        viewStore.send(.animationStateReset)
                                    }
                                )
                            }
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

