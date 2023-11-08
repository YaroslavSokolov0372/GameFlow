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
        
        
        var detailDomainInfoState = DetailInfoDomain.State()
    }
    
    enum Action: BindableAction {
        case path(StackAction<Path.State, Path.Action>)
        case tabSelected(SeriesType)
        case scrollOffsetChanged(CGFloat)
        case binding(BindingAction<State>)
        case animationStateStarted
        case animationStateReset
        case seriesTapped
//        case ongoingSeriesAction(TournamentsListDomain.Action)
        
        case detailInfoDomainAction(DetailInfoDomain.Action)
    }
    
    
    //MARK: - Navigaition Stack
    struct Path: Reducer {
        
        enum State: Equatable {
            case detailInfo(DetailInfoDomain.State)
            case matchList(MatchesListDomain.State)
            case ongoingMatchList(OngoingMatchListDomain.State)
            
        }
        enum Action {
            case detailInfo(DetailInfoDomain.Action)
            case matchesList(MatchesListDomain.Action)
            case ongoingMatchList(OngoingMatchListDomain.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: /State.detailInfo, action: /Action.detailInfo) {
                DetailInfoDomain()
            }
            Scope(state: /State.matchList, action: /Action.matchesList) {
                MatchesListDomain()
            }
            Scope(state: /State.ongoingMatchList, action: /Action.ongoingMatchList) {
                OngoingMatchListDomain()
            }
            
//            Reduce { state, action in
//                switch action {
////                case .detailInfo(.closeButtonTapped):
//                case .detailInfo(.closeButtonTapped):
//                    
////                    print("Yep")
//                    
////                    MainDomain.State.path.popLast()
//                    return .none
//                default: return .none
//                }
//            }
        }
    }
    
    enum SeriesType: String, CaseIterable {
        case ongoing = "ONGOING"
        case upcoming = "UPCOMING"
        case latest = "LATEST"
        
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
//        Scope(state: \.detailDomainInfoState, action: /Action.detailInfoDomainAction) {
//            DetailInfoDomain()
//        }
        
        Reduce { state, action in
            switch action {
                //            case .ongoingSeriesAction(.seriesViewTapped(let serie)):
                ////                print("hello")
                //                state.path.append(.detailInfo(.init(serie: serie, id: .init())))
                //                return .none
                //            case .ongoingSeriesAction(_):
                //                return .none

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
                
                
                
//            case .path(.popFrom(id: 312312)):
//                return .none
//            case .path(.element(id: , action: .detailInfo(.closeButtonTapped))):
//                guard case .detailInfo(DetailInfoDomain.State()) = state.path[id: "DetailInfo"]
//                else { return .none }
//                print("hello world")
//                return .none
                
                //            case .detailInfoDomainAction()
//            case .detailInfoDomainAction(.closeButtonTapped):
//                print("wtf?")
//                return .none
                
            case .seriesTapped:
                state.path.append(.detailInfo(DetailInfoDomain.State()))
                //                state.path
                return .none
                
                
                //            case .path(.element(id: 0, action: .detailInfo(.closeButtonTapped))):
                //                guard case .detailInfo(DetailInfoDomain.State()) = state.path[id: 0] else {
                //                    print("Hello")
                //                    return .none
                //                }
                //                state.path.pop(from: 0)
                //                return .none
//            case .detailInfoDomainAction(.closeButtonTapped):
//                print("Ali luya")
//                return .none
                //            case .detailInfoDomainAction(.closeButtonTapped):
                //                print("Closse button Pressed")
                ////                state.path.removeLast()
                //                return .none
                
                
            case .path(_):
                return .none
            default: return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        BindingReducer()
    }
    

}

struct MainView: View {
    
    var store: StoreOf<MainDomain>
    
    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) })) {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    GeometryReader { geo in
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
                                        .onTapGesture(perform: {
                                            viewStore.send(.seriesTapped)
                                        })
                                        
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
                                        
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundStyle(Color("Black", bundle: .main))
                                            .frame(width: 350, height: 60)
                                            .overlay(content: {
                                                HStack {
                                                    ForEach(MainDomain.SeriesType.allCases, id: \.self) { type in
                                                        Button {
                                                            
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                viewStore.send(.tabSelected(type))
                                                                
                                                                viewStore.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                                
                                                                viewStore.send(.animationStateStarted)
                                                                
                                                            }
                                                            
                                                            
                                                        } label: {
                                                            Text(type.rawValue)
//                                                            switch type {
//                                                            case .ongoing:
//                                                                Text("ONGOING")
//                                                            case .upcoming:
//                                                                Text("UPCOMING")
//                                                            case .latest:
//                                                                Text("LATEST")
//                                                            }
                                                        }
                                                        .frame(maxWidth: 106, alignment: .center)
                                                        .disabled(viewStore.tapState.status ? true : false)
                                                    }
                                                    
                                                }
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 16))
                                                .background(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .foregroundStyle(Color("Orange", bundle: .main))
                                                        .frame(width: 113, height: 50)
                                                        .overlay(content: {
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                                .blur(radius: 10)
                                                                .opacity(0.6)
                                                        })
                                                        .offset(x:  -113 - (115 * viewStore.scrollProgress))
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
                         then: DetailInfoView.init(store:)).navigationBarBackButtonHidden()
                case .matchList:
                    CaseLet(
                        /MainDomain.Path.State.matchList,
                         action: MainDomain.Path.Action.matchesList,
                         then: MatchesListView.init(store:)).navigationBarBackButtonHidden()
                case .ongoingMatchList:
                    CaseLet(
                        /MainDomain.Path.State.ongoingMatchList,
                         action: MainDomain.Path.Action.ongoingMatchList,
                         then: OngoingMatchListView.init(store:)).navigationBarBackButtonHidden()
                }
            }

        
        
        
        
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
