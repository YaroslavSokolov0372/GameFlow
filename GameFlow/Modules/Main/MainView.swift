//
//  MainView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct MainDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var series: [Serie] = Serie.sample
        @BindingState var scrollProgress: CGFloat = .zero
        @BindingState var currentTab = SeriesType.ongoing
        @BindingState var tapState: AnimationState = .init()
        @BindingState var disableOffsetRead = false
        @BindingState var isFetching = false
        var tabBarState = CustomTabBarDomain.State()
    }
    
    enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case badConnection
        case showConnectionMessage
        case tabSelected(SeriesType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset
        case startFetchData
        case fetchFirestoreDataResult(TaskResult<[Serie]>)
        case tapped
        case timeOutGesture
        case tabBarAction(CustomTabBarDomain.Action)
        
//        case serieListAction(SeriesListResketchDomain.Action)

    }
    
    let apiClient = ApiClient()
    let network = NetworkMonitor()

    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.tabBarState, action: /Action.tabBarAction) {
            CustomTabBarDomain()
        }
        
        Reduce { state, action in
            switch action {
                
            case .tapped:
                state.disableOffsetRead = false
                return .none
            case .timeOutGesture:
                state.disableOffsetRead = true
                return .none
                
                
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
                
                
            case .startFetchData:
                state.isFetching = true
                return .run { send in
                    await send(.tabBarAction(.startFetching))
                    try await Task.sleep(for: .seconds(2))
//                    await send(.fetchFirestoreDataResult(TaskResult { try await apiClient.getFirestoreSeries() }))
                    await send(.fetchFirestoreDataResult(TaskResult { try await apiClient.getData() }))
                }
            case .fetchFirestoreDataResult(.success(let series)):
                state.series = series
                state.isFetching = false
                return .run { send in
                    await send(.tabBarAction(.stopFetching))
                }
            case .fetchFirestoreDataResult(let error):
                print(error)
                return .run { send in
                    await send(.tabBarAction(.showErrorMessage(error)))
                    await send(.tabBarAction(.stopFetching))
                }
            case .binding:
                return .none
            default: return .none
            }
        }
        BindingReducer()
    }
}

struct MainView: View {
    
    var store: StoreOf<MainDomain>

    
    var body: some View {
        
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            NavigationView(content: {
                
                GeometryReader { geo in
                    
                    ZStack {
                        
                        Color("Black", bundle: .main)
                            .ignoresSafeArea()
                        
                        VStack {
                            
                            HStack {
                                
                                Text("Series")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.bold, size: 20))
                                    .frame(width: geo.size.width, alignment: .center)
                            }
                            .padding(.vertical, 15)
                            
                            TabView(selection: viewStore.$currentTab) {
                                ForEach(SeriesType.allCases, id: \.rawValue) { type in
                                    
                                    
                                    switch type {
                                        
                                    case .ongoing:
                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(series: viewStore.isFetching ? viewStore.series : viewStore.series.ongoing, isFetching: viewStore.isFetching), reducer: {
                                            SeriesListDomain()
                                        }))
                                        .tag(type)
                                        .offsetX(type == viewStore.currentTab) { size in
                                            if !viewStore.disableOffsetRead {
                                                let minX = size.minX
                                                let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                                let pageProgress = pageOffset / geo.size.width
                                                
                                                
                                                let limitation = max(min(pageProgress, 0), -CGFloat(SeriesType.allCases.count - 1))
                                                if !viewStore.tapState.status {
                                                    viewStore.send(.scrollOffsetChanged(limitation))
                                                }
                                            }
                                        }
                                        
                                    case .upcoming:
                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(series: viewStore.isFetching ? viewStore.series : viewStore.series.upcoming, isFetching: viewStore.isFetching), reducer: {
                                            SeriesListDomain()
                                        }))
                                        .tag(type)
                                        .offsetX(type == viewStore.currentTab) { size in
                                            if !viewStore.disableOffsetRead {
                                                let minX = size.minX
                                                let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                                let pageProgress = pageOffset / geo.size.width
                                                
                                                
                                                let limitation = max(min(pageProgress, 0), -CGFloat(SeriesType.allCases.count - 1))
                                                if !viewStore.tapState.status {
                                                    viewStore.send(.scrollOffsetChanged(limitation))
                                                }
                                            }
                                        }
                                        
                                    case .latest:
                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(series: viewStore.isFetching ? viewStore.series : viewStore.series.latest, isFetching: viewStore.isFetching), reducer: {
                                            SeriesListDomain()
                                        }))
                                        .tag(type)
                                        .offsetX(type == viewStore.currentTab) { size in
                                            if !viewStore.disableOffsetRead {
                                                let minX = size.minX
                                                let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                                let pageProgress = pageOffset / geo.size.width
                                                
                                                
                                                let limitation = max(min(pageProgress, 0), -CGFloat(SeriesType.allCases.count - 1))
                                                if !viewStore.tapState.status {
                                                    viewStore.send(.scrollOffsetChanged(limitation))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .ignoresSafeArea(edges: [.bottom])
                            .onTapGesture {
                                self.store.send(.timeOutGesture)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.store.send(.tapped)
                                }
                            }
                        }
                        .overlay {
                            CustomTabBar(store: self.store.scope(state: \.tabBarState, action: MainDomain.Action.tabBarAction))
                        }
                    }
                }
            })
            .task {
                self.store.send(.startFetchData)
            }
        }
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
