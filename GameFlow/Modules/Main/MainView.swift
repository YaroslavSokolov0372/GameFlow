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
        case animationStateStarted
        case animationStateReset
        case binding(BindingAction<State>)
        case seriesTapped
//        case ongoingSeriesAction(TournamentsListDomain.Action)
        
        case detailInfoDomainAction(DetailInfoDomain.Action)
    }
    
    
    //MARK: - Navigaition Stack
    struct Path: Reducer {
        
        enum State: Equatable {
//            case detailInfo(DetailInfoDomain.State)
//            case matchList(MatchesListDomain.State)
            
//            case ongoingMatchList(OngoingMatchListDomain.State)
            
//            case matchDetail(MatchDetailDomain.State)
//            case teamDetail(TeamDetailDomain.State)
            
        }
        enum Action {
//            case detailInfo(DetailInfoDomain.Action)
//            case matchesList(MatchesListDomain.Action)
            
//            case ongoingMatchList(OngoingMatchListDomain.Action)
            
//            case matchDetail(MatchDetailDomain.Action)
//            case teamDetail(TeamDetailDomain.Action)
        }
        
        var body: some Reducer<State, Action> {
//            Scope(state: /State.detailInfo, action: /Action.detailInfo) {
//                DetailInfoDomain()
//            }
//            Scope(state: /State.matchList, action: /Action.matchesList) {
//                MatchesListDomain()
//            }
//            Scope(state: /State.ongoingMatchList, action: /Action.ongoingMatchList) {
//                OngoingMatchListDomain()
//            }
//            Scope(state: /State.matchDetail, action: /Action.matchDetail) {
//                MatchDetailDomain()
//            }
//            Scope(state: /State.teamDetail, action: /Action.teamDetail) {
//                TeamDetailDomain()
//            }
            
            Reduce { state, action in
                switch action {
//                case .detailInfo(.closeButtonTapped):
//                case .detailInfo(.closeButtonTapped):
                    
//                    print("Yep")
                    
//                    MainDomain.State.path.popLast()
//                    return .none
                default: return .none
                }
            }
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
        
        
        Reduce { state, action in
            switch action {
                
                //MARK: - MainView Actions
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
                
                
                
                
                
                //MARK: - Navigation
//            case .seriesTapped:
//                state.path.append(.detailInfo(DetailInfoDomain.State()))
//                return .none
//                
//            case .path(.element(id: _, action: .detailInfo(.ongoingMatchTapped))):
//                state.path.append(.matchDetail(.init()))
//                return .none
//            case .path(.element(id: _, action: .detailInfo(.teamDetailTapped))):
//                state.path.append(.teamDetail(.init()))
//                return .none
//            case .path(.element(id: _, action: .detailInfo(.matchListTapped))):
//                state.path.append(.matchList(.init()))
//                return .none
//            case .path(.element(id: _, action: .detailInfo(.closeButtonTapped))):
//                state.path.popLast()
//                return .none
//            case .path(.element(id: _, action: .matchesList(.backButtonTapped))):
//                state.path.popLast()
//                return .none
//            case .path(.element(id: _, action: .matchDetail(.backButtonTapped))):
//                state.path.popLast()
//                return .none
//            case .path(.element(id: _, action: .teamDetail(.backButtonTapped))):
//                state.path.popLast()
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
    
//    @Environment(\.dismiss) var dismiss
    var store: StoreOf<MainDomain>
//    var fireStoreManager = FirestoreManager()
    let pandascoreManager = PandascoreManager()
//    let date = Date().ISO8601Format()
//    let date = Date().ISO8601Format(.iso8601(timeZone: .autoupdatingCurrent))
//    let date = Date.ISOStringFromDate(date: Date()).ISOfotmattedString()
//    let date = Date()
//    let newDate = Calendar(identifier: .iso8601).dateBySetting(timeZone: .init(abbreviation: "UTC")!, of: Date())
    
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
                                        //                                        NavigationLink {
                                        //                                            DetailInfoView(store: Store(initialState: DetailInfoDomain.State(), reducer: {
                                        //                                                DetailInfoDomain()
                                        //                                            }))
                                        //                                        } label: {
                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                            SeriesListDomain()
                                        }))
                                        //                                        }
                                        
                                        //                                        SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                        //                                            SeriesListDomain()
                                        //                                        }))
                                        //                                        .environmentObject(dismiss)
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
                                            .frame(width: 370, height: 60)
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
                                                        .frame(maxWidth: 115, alignment: .center)
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
                                                        .offset(x:  -120 - (120 * viewStore.scrollProgress))
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
                        .task({
//                            await self.fireStoreManager.shouldPandascoreReq()
                            do {
//                                try await self.pandascoreManager.getSeries()
                            } catch {
                                
                            }
                        })
                    }
                }
            } destination: { state in
//                switch state {
//                    
////                case .detailInfo:
////                    CaseLet(
////                        /MainDomain.Path.State.detailInfo,
////                         action: MainDomain.Path.Action.detailInfo,
////                         then: DetailInfoView.init(store:)).navigationBarBackButtonHidden()
////                case .matchList:
////                    CaseLet(
////                        /MainDomain.Path.State.matchList,
////                         action: MainDomain.Path.Action.matchesList,
////                         then: MatchesListView.init(store:)).navigationBarBackButtonHidden()
////                case .ongoingMatchList:
////                    CaseLet(
////                        /MainDomain.Path.State.ongoingMatchList,
////                         action: MainDomain.Path.Action.ongoingMatchList,
////                         then: OngoingMatchListView.init(store:)).navigationBarBackButtonHidden()
////                case .matchDetail:
////                    CaseLet(
////                        /MainDomain.Path.State.matchDetail,
////                         action: MainDomain.Path.Action.matchDetail,
////                         then: MatchDetailView.init(store:)).navigationBarBackButtonHidden()
////                case .teamDetail:
////                    CaseLet(
////                        /MainDomain.Path.State.teamDetail,
////                         action: MainDomain.Path.Action.teamDetail,
////                         then: TeamDetailView.init(store:)).navigationBarBackButtonHidden()
//                    
//                    
////                    CaseLet(
////                        /MainDomain.Path.State.teamDetail,
////                         action: MainDomain.Path.Action.teamDetail,
////                         then: MatchDetailView.init(store:))
//                    
//                }
            
            }

        
        
        
        
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
