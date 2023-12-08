//
//  CustomTabBar.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct CustomTabBarDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var currentTab: SeriesType = .ongoing
        var scrollProgress: CGFloat = .zero
        var tapState: AnimationState = .init()
        var errorMessage = ""
        var showErrorMessage = false
        var isFetching = false
        var attemps: CGFloat = 5
    }
    
    enum Action {
        case tabSelected(SeriesType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset
        case showErrorMessage(Error)
        case startFetching
        case storShowingError
        case stopFetching
    }
    
    let network = NetworkMonitor()
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .stopFetching:
                state.isFetching = false
                return .none
            case .startFetching:
                state.isFetching = true
                return .none
            case .showErrorMessage(let error):
                state.attemps += 1
                state.showErrorMessage = true
                
                switch error {
                case PandascoreError.pandaInvalidURL:
                    if !network.isConnected {
                        state.errorMessage = "No Internet Connection"
                    } else {
                        state.errorMessage = "Server Error. Try Again Later"
                    }
                case WebScrapingError.invalidURL:
                    
                    if !network.isConnected {
                        state.errorMessage = "No Internet Connection"
                    } else {
                        state.errorMessage = "Server Error. Try Again Later"
                    }
                default: state.errorMessage = "Server Error. Try Again Later"
                }
                return .run { send in
                    try? await Task.sleep(for: .seconds(3))
                    await send(.storShowingError)
                }
                
            case .storShowingError:
                
//                state.isFetching = false
                
                state.showErrorMessage = false
                state.errorMessage = ""
                return .none
                
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

struct CustomTabBar: View {
    
    var store: StoreOf<CustomTabBarDomain>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                ZStack {
//                    VStack {
//                        Button {
////                            self.store.send(.showErrorMessage(PandascoreError.pandaInvalidURL))
//                            self.store.send(.showErrorMessage(PandascoreError.pandaFetchingFailed))
//                        } label: {
//                            Text("Show An Error")
//                                .foregroundStyle(Color("Orange", bundle: .main))
//                        }
//                        
//                        Button {
//                                self.store.send(.startFetching)
//                        } label: {
//                            Text("Start Fetching")
//                                .foregroundStyle(Color("Orange", bundle: .main))
//                        }
//                    }
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
                                            ForEach(SeriesType.allCases, id: \.self) { type in
                                                Button {
                                                    
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        self.store.send(.tabSelected(type))
                                                        
                                                        self.store.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                        
                                                        self.store.send(.animationStateStarted)

                                                    }
                                                } label: {
                                                    Text(type.rawValue)
                                                }
                                                .frame(maxWidth: 113, alignment: .center)
                                                .disabled(viewStore.tapState.status ? true : false)
                                            }
                                            .opacity(viewStore.showErrorMessage ? 0 : 1)
                                            .opacity(viewStore.isFetching ? 0 : 1)
                                        }
                                        .overlay(alignment: .center, content: {
                                            
                                                Text(viewStore.errorMessage)
                                                    .font(.gilroy(.bold, size: 20))
                                                    
                                                ProgressView()
                                                    .scaleEffect(1.3)
                                                    .tint(.white)
                                                    .opacity(viewStore.isFetching ? viewStore.showErrorMessage ? 0 : 1 : 0)
                                                    .offset(y: viewStore.isFetching ? 0 : 20)
                                        })
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.bold, size: 16))
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .frame(width: viewStore.isFetching ? 360 : viewStore.showErrorMessage ? 360 : 120, height: 50)
                                                .overlay(content: {
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .foregroundStyle(Color("Orange", bundle: .main))
                                                        .blur(radius: 10)
                                                        .opacity(0.6)
                                                })
                                                .offset(x: viewStore.isFetching ? 0 : viewStore.showErrorMessage ? 0 : -120 - (120 * viewStore.scrollProgress))
                                                
                                        )
                                        .modifier(
                                            AnimationEndCallBack(endValaue: viewStore.tapState.progress) {
                                                viewStore.send(.animationStateReset)
    
                                            }
                                        )
                                        .modifier(Shake(animatableData: viewStore.attemps))
                                        .animation(.easeIn(duration: 0.35).repeatCount(1, autoreverses: false), value: viewStore.showErrorMessage)
                                        .animation(.easeOut(duration: 0.35), value: viewStore.isFetching)
                                        
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
    CustomTabBar(store: Store(initialState: CustomTabBarDomain.State(currentTab: .ongoing, scrollProgress: .zero, tapState: .init()), reducer: {
        CustomTabBarDomain()
    }))
}
