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
        @BindingState var scrollProgress: CGFloat = .zero
        @BindingState var currentTab = SeriesType.ongoing
        @BindingState var tapState: AnimationState = .init()
        var path = StackState<Path.State>()
//        var ongoingSeriesState = TournamentsListDomain.State(apiFetchType: .ongoingSeries)
    }
    
    enum Action: BindableAction {
        case path(StackAction<Path.State, Path.Action>)
        case tabSelected(SeriesType)
        case scrollOffsetChanged(CGFloat)
        case binding(BindingAction<State>)
        case animationStateStarted
        case animationStateReset
//        case ongoingSeriesAction(TournamentsListDomain.Action)
        
    }
    
    enum SeriesType: String, CaseIterable {
        case ongoing = "Ongoing"
        case upcoming = "Upcoming"
        case latest = "Latest"
        
        var index: Int {
            return SeriesType.allCases.firstIndex(of: self) ?? 0
        }
        
        var count: Int {
            return SeriesType.allCases.count - 1
        }
        
        
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        
        
//        Scope(state: \.ongoingSeriesState, action: /Action.ongoingSeriesAction) {
//            TournamentsListDomain()
//        }
        
        
        Reduce { state, action in
            switch action {
//            case .ongoingSeriesAction(.seriesViewTapped(let serie)):
////                print("hello")
//                state.path.append(.detailInfo(.init(serie: serie, id: .init())))
//                return .none
//            case .ongoingSeriesAction(_):
//                return .none
            case .path(_):
                return .none
            case .tabSelected(let type):
                state.currentTab = type
                return .none
            case .scrollOffsetChanged(let offsetX):
                state.scrollProgress = offsetX
                return .none
            case .binding(_):
                return .none
                
            case .animationStateStarted:
                state.tapState.startAnimation()
                return .none
            case .animationStateReset:
                state.tapState.reset()
                return .none
                //            default: return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        BindingReducer()
    }
    
    struct Path: Reducer {
        
        enum State: Equatable {
            case detailInfo(DetailInfoDomain.State)
        }
        enum Action {
            case detailInfo(DetailInfoDomain.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: /State.detailInfo, action: /Action.detailInfo) {
                DetailInfoDomain()
            }
        }
    }
}

struct MainView: View {
    
    var store: StoreOf<MainDomain>
    
    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) })) {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    GeometryReader { geo in
                        let width = geo.size.width
                    ZStack {
                            Color("Black", bundle: .main)
                                .ignoresSafeArea()
                            
                            VStack {
                                
                                //MARK: - Series
                                
                                
                                TabView(selection: viewStore.binding(get: { $0.currentTab } , send: MainDomain.Action.tabSelected)) {
                                    
                                    ForEach(MainDomain.SeriesType.allCases, id: \.rawValue) { type in
                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                            SeriesListDomain()
                                        }))
                                        .tag(type)
                                        
                                        .offsetX(type == viewStore.currentTab) { size in
                                            let minX = size.minX
                                            let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                            let pageProgress = pageOffset / geo.size.width
                                            

                                            let limitation = max(min(pageProgress, 0), -CGFloat(MainDomain.SeriesType.allCases.count - 1))
                                            if !viewStore.tapState.status {
                                                viewStore.send(.scrollOffsetChanged(limitation))
//                                                print(limitation)
                                            }
//                                            if tapState.status {
//                                                viewStore.send(.scrollOffsetChanged(pageProgress))
//                                            }
//                                            print(-115 - (115 * limitation))
                                        }
                                    }
                                    
                                    
                                    

//                                    
//                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
//                                        SeriesListDomain()
//                                    }))
//                                    .tag("Upcoming")
//                                    
//                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
//                                        SeriesListDomain()
//                                    }))
//                                    .tag("Latest")
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                .ignoresSafeArea(edges: [.bottom])
                                
                                
                                
                                
                            }
                            .overlay {
                                ZStack {
                                    VStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(Color("Black", bundle: .main))
                                                .frame(height: 55)
                                                .mask {
                                                    LinearGradient(colors: [.white, .white, .white.opacity(0.0), .white.opacity(0.0)], startPoint: .top, endPoint: .bottom)
                                                }
                                            
                                            //MARK: - Search
                                            
                                            SearchField(store: Store(initialState: SearchFieldDomain.State(), reducer: {
                                                SearchFieldDomain()
                                            }))
                                            
                                        }
                                        Spacer()
                                            
                                        //MARK: - TabBar
//                                        TabBarView(store: Store(initialState: TabBarDomain.State(), reducer: {
//                                            TabBarDomain()
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                            .frame(width: 350, height: 60)
                                            .overlay(content: {
//                                                HStack(spacing: 0) {
//                                                    
//                                                    Button {
////                                                        withAnimation {
//                                                            viewStore.send(.tabSelected(.ongoing))
////                                                            viewStore.send(.scrollOffsetChanged(CGFloat(viewStore.currentTab.index) * geo.size.width))
////                                                        viewStore.send(.scrollOffsetChanged(CGFloat(viewStore.currentTab.index * geo.size.width)))
////                                                        }
//
//                                                    } label: {
//                                                        Text("ONGOING")
//                                                            .frame(width: 115)
//                                                        
//                                                    }
//                                                    
//                                                    
//                                                    Button {
//                                                        DispatchQueue.main.async {
//                                                            viewStore.send(.tabSelected(.upcoming))
//                                                            //                                                            viewStore.send(.scrollOffsetChanged(2 * 115))
//                                                            viewStore.send(.scrollOffsetChanged(0))
//                                                            
//                                                        }
////                                                        withAnimation {
////                                                            
////                                                            
////                                                            viewStore.send(.tabSelected(.upcoming))
//////                                                            viewStore.send(.scrollOffsetChanged(CGFloat(viewStore.currentTab.index) * geo.size.width))
////                                                        }
//                                                        
//                                                        
//                                                    } label: {
//                                                        Text("UPCOMING")
//                                                            .frame(width: 115)
//                                                    }
//                                                    
//                                                    
//                                                    Button {
//                                                        withAnimation {
//                                                            
////                                                            viewStore.send(.tabSelected(.latest))
////                                                            viewStore.send(.scrollOffsetChanged(CGFloat(viewStore.currentTab.index) * geo.size.width))
//                                                        }
//                                                    } label: {
//                                                        Text("LATEST")
//                                                            .frame(width: 115)
//                                                        
//                                                    }
//                                                }
                                                HStack {
                                                    ForEach(MainDomain.SeriesType.allCases, id: \.self) { type in
                                                        Button {
                                                            
                                                            withAnimation(.easeInOut(duration: 0.6)) {
                                                                viewStore.send(.tabSelected(type))
                                                                
                                                                viewStore.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                                
                                                                viewStore.send(.animationStateStarted)
                                                                
                                                            }
                                                            
                                                            
                                                        } label: {
                                                            switch type {
                                                            case .ongoing:
                                                                Text("ONGOING")
                                                            case .upcoming:
                                                                Text("UPCOMING")
                                                            case .latest:
                                                                Text("LATEST")
                                                            }
                                                        }
                                                        .frame(width: 111)
                                                    }
                                                    
                                                }
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 16))
                                                .background(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .foregroundStyle(Color("Orange", bundle: .main))
                                                        .frame(width: 115, height: 50)
                                                        .overlay(content: {
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                                .blur(radius: 10)
                                                                .opacity(0.6)
                                                        })
                                                        .offset(x:  -115 - (115 * viewStore.scrollProgress))
                                                )
                                                .modifier(
                                                    AnimationEndCallBack(endValaue: viewStore.tapState.progress) {
                                                        viewStore.send(.animationStateReset)
                                                            
                                                    }
                                                )
                                            })
//                                            .animation(.easeInOut(duration: 0.2), value: viewStore.scrollProgress)
                                    }
                                }
                            }
                        }
                    }
                }
            } destination: { state in
                switch state {
                case .detailInfo:
                    CaseLet(
                        /MainDomain.Path.State.detailInfo,
                         action: MainDomain.Path.Action.detailInfo,
                         then: DetailInfoView.init(store:))
                    
                }
            }

        
        
        
        
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
