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
        var path = StackState<Path.State>()
//        var ongoingSeriesState = TournamentsListDomain.State(apiFetchType: .ongoingSeries)
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
//        case ongoingSeriesAction(TournamentsListDomain.Action)
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
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
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
//                    ZStack {
//                        
////                        Color.mainBack
////                            .ignoresSafeArea()
//                        
//                        VStack {
//                            //MARK: - Ongoing Tournaments
//                            HStack {
//                                Text("Ongoing Tournaments")
////                                    .foregroundStyle(.gameListCellForeground)
//                                    .font(.title2)
//                                    .bold()
//                                
//                                
//                                Spacer()
//                                
//                                Button {
//                                    
//                                } label: {
//                                    Image(systemName: "bell.fill")
////                                        .foregroundStyle(.gameListCellForeground)
//                                        .font(.system(size: 20))
//                                }
//                            }
//                            .padding(10)
//                            .padding(.leading, 10)
//                            .padding(.trailing, 15)
//                            
//                            //MARK: - Ongoing Tournaments List
//                            
////                            TournamentListView(store: Store(initialState: TournamentListDomain.State( apiFetchType: .ongoingTournaments), reducer: {
////                                TournamentListDomain()
////                            }))
//                            SeriesListView(store: self.store.scope(state: \.ongoingSeriesState, action: MainDomain.Action.ongoingSeriesAction))
//                            
//                            //MARK: - Upcoming Tournaments List
//                            HStack {
//                                Text("Upcoming Tournaments")
//                                    .foregroundStyle(.gameListCellForeground)
//                                    .font(.title2)
//                                    .bold()
//                                
//                                Spacer()
//                                
//                                Button {
//                                    
//                                } label: {
//                                    Image(systemName: "bell")
//                                        .foregroundStyle(.gameListCellForeground)
//                                        .font(.system(size: 20))
//                                }
//                            }
//                            .padding(10)
//                            .padding(.leading, 10)
//        //                    .padding(.trailing, 35)
//                            .padding(.trailing, 15)
//                            
//                            
//                            //MARK: - Upcoming TOurnamnets List
//                            SeriesListView(store: Store(initialState: SeriesListDomain.State( apiFetchType: .upcommingSeries), reducer: {
//                                SeriesListDomain()
//                            }))
//                            
//                            Spacer()
//                        }
//                    }
                    
                    GeometryReader { geo in
                    ZStack {
                            Color("Black", bundle: .main)
                                .ignoresSafeArea()
                            
                            VStack() {
                                
                                
                                //MARK: - Search
                                
                                SearchField(store: Store(initialState: SearchFieldDomain.State(), reducer: {
                                    SearchFieldDomain()
                                }))
                                
                                
                                //MARK: - Series
                                TabView {
                                    
                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                        SeriesListDomain()
                                    }))
                                    
                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                        SeriesListDomain()
                                    }))
                                    
                                    SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
                                        SeriesListDomain()
                                    }))
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                .ignoresSafeArea()
                                
                            }
                            .overlay {
                                ZStack {
                                    VStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(Color("Black", bundle: .main))
                                                .frame(height: 70)
                                                .mask {
                                                    LinearGradient(colors: [.white, .white, .white.opacity(0.0), .white.opacity(0.0)], startPoint: .top, endPoint: .bottom)
                                                }
                                            
                                            RoundedRectangle(cornerRadius: 25)
                                                .frame(width: 350, height: 50)
                                        }
                                        Spacer()
                                    }
                                }
//                                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                                .offset(y: 53)
                                
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
