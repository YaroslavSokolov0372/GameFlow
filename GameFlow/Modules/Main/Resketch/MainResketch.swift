//
//  MainResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/11/2023.
//

import SwiftUI
import ComposableArchitecture


enum Path: Equatable, Hashable {
    
    case detailView(Serie)
//        case matchListView
//        case teamView
//        case matchDetailsView
}

struct MainResketchDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var championChip: ChampionShip = ChampionShip(series: [])
        @BindingState var scrollProgress: CGFloat = .zero
        @BindingState var currentTab = SeriesType.ongoing
        @BindingState var tapState: AnimationState = .init()
        
        
        
        @BindingState var path: [Path] = []
        
        
        var seriesState = SeriesListResketchDomain.State()
        var detailInfoState = DetailInfoResketchDomain.State(serie: nil)
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case tabSelected(SeriesType)
        case scrollOffsetChanged(CGFloat)
        case animationStateStarted
        case animationStateReset
        case startFetchFirestoreData
        case fetchFireStoreDataResult(TaskResult<ChampionShip>)
        
        
        case detaileInfoAction(DetailInfoResketchDomain.Action)
        case seriesAction(SeriesListResketchDomain.Action)
        case pathAdded(Path)
        case popLast


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
    
    var firestoreManager = FirestoreManager()

    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.detailInfoState, action: /Action.detaileInfoAction) {
            DetailInfoResketchDomain()
        }
        
        Scope(state: \.seriesState, action: /Action.seriesAction) {
            SeriesListResketchDomain()
        }
        
        Reduce { state, action in
            switch action {

            case .detaileInfoAction(.closeButtonTapped):
                print("Detail view back button pressed")
                return .run { send in
                    await send(.popLast)
                }
                
                
            case .seriesAction(.serieTapped(let serie)):
                print("Main view print series tapped")
                state.detailInfoState.serie = serie
                state.path.append(.detailView(serie))
                return .none
//                return .run { send in
//                    await send(.pathAdded(.detailView(serie)))
//                }
                
            case .pathAdded(let path):
                state.path.append(path)
                return .none
                
            case .popLast:
                state.path = []
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
                
            case .startFetchFirestoreData:
                return .run { send in
                    await send(.fetchFireStoreDataResult( TaskResult { try await firestoreManager.getData() }))
                }
            case .fetchFireStoreDataResult(.success(let championChip)):
                state.championChip = championChip
                state.seriesState.series = championChip.series
                return .none
            case .fetchFireStoreDataResult(let error):
                print(error)
                return .none
            case .binding:
                return .none
            default: return .none
            }
        }
        BindingReducer()
    }
}

struct MainResketch: View {
    
    var store: StoreOf<MainResketchDomain>
    @State var date = Date()
    @State var path: [Int] = []
    
    var body: some View {
        
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
//            NavigationStack(path: viewStore.binding(get: { $0.path }, send: MainResketchDomain.Action.pathAdded)) {
            
//            NavigationStack(path: viewStore.$path) {
            NavigationView(content: {
                
            
                GeometryReader { geo in
                    
                    ZStack {
                        
                        Color("Black", bundle: .main)
                            .ignoresSafeArea()
                        
                        VStack {
                            
//                            TabView(selection: viewStore.binding(get: { $0.currentTab } , send: MainResketchDomain.Action.tabSelected)) {
                            TabView(selection: viewStore.$currentTab) {
                                
                                ForEach(MainResketchDomain.SeriesType.allCases, id: \.rawValue) { type in
                                    
//                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
//                                        SeriesListDomain()
//                                    }))
                                    
                                    
//                                    SeriesListViewResketch(store: Store(initialState: SeriesListResketchDomain.State(series: viewStore.championChip.series), reducer: {
//                                        SeriesListResketchDomain()
//                                    }))
                                    
                                    SeriesListViewResketch(store: self.store.scope(state: \.seriesState, action: MainResketchDomain.Action.seriesAction))
                                    
//                                    SeriesListView(store: self.store.scope(state: \.ongoingSeriesState, action: MainDomain.Action.ongoingSeriesAction))
                                    
                                    .tag(type)
//                                    .onTapGesture(perform: {
//                                        //                                viewStore.send(.seriesTapped)
//                                    })
                                    .offsetX(type == viewStore.currentTab) { size in
                                        let minX = size.minX
                                        let pageOffset = minX - (geo.size.width * CGFloat(type.index))
                                        let pageProgress = pageOffset / geo.size.width
                                        
                                        
                                        let limitation = max(min(pageProgress, 0), -CGFloat(MainDomain.SeriesType.allCases.count - 1))
                                        if !viewStore.tapState.status {
                                            viewStore.send(.scrollOffsetChanged(limitation))
                                        }
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
                                    
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(Color("Black", bundle: .main))
                                        .frame(width: 370, height: 60)
                                        .overlay(content: {
                                            HStack {
                                                ForEach(MainResketchDomain.SeriesType.allCases, id: \.self) { type in
                                                    Button {
                                                        
                                                        withAnimation(.easeInOut(duration: 0.3)) {
                                                            viewStore.send(.tabSelected(type))
                                                            
                                                            viewStore.send(.scrollOffsetChanged(-CGFloat(type.index)))
                                                            
                                                            viewStore.send(.animationStateStarted)
                                                            
                                                        }
                                                    } label: {
                                                        Text(type.rawValue)
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
                                }
                            }
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                        }
                        
                    }

                    
                }
//                .navigationDestination(for: Path.self, destination: { path in
//                    switch path {
//                    case .detailView(let serie):
////                        DetailInfoResketchView(
////                            store: Store(
////                                initialState: DetailInfoResketchDomain.State(serie: serie),
////                                reducer: {
////                            DetailInfoResketchDomain()
////                        }))
//                        
//                        DetailInfoResketchView(store: self.store.scope(state: \.detailInfoState, action: MainResketchDomain.Action.detaileInfoAction)).navigationBarBackButtonHidden()
//                    }
//                })
//            }
            })
            .task {
                self.store.send(.startFetchFirestoreData)
            }
            
        }
    }
}

#Preview {
    MainResketch(store: Store(initialState: MainResketchDomain.State(), reducer: {
        MainResketchDomain()
    }))
}
