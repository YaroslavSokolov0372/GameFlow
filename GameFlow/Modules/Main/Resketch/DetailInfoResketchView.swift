//
//  DetailInfoResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture


struct DetailInfoResketchDomain: Reducer {
    
    struct State: Equatable {
        
        var serie: Serie?
        
        @BindingState var currentTab = 0
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(Int)
        
        case closeButtonTapped
//        case ongoingMatchTapped
//        case teamDetailTapped
//        case matchListTapped
    }
    
//    @Dependency(\.dismiss) var dismiss
    
//    @Environment(\.isPresented) var isPresented
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.currentTab = tab
                return .none
                
            case .closeButtonTapped:
                print("Close button tapped")
                return .run { _ in
//                    await self.dismiss()
                }
//            case .ongoingMatchTapped:
//                return .run { _ in
//
//                }
//            case .teamDetailTapped:
//                return .run { send in
//
//                }
//            case .matchListTapped:
//                return .run { send in
//
//                }
            default: return .none
            }
            
        }
        BindingReducer()
    }
}

struct DetailInfoResketchView: View {
    
    @Environment(\.dismiss) var dismiss
    var store: StoreOf<DetailInfoResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
//            NavigationView(content: {
                
                GeometryReader { geo in
                    ZStack {
                        Color("Black", bundle: .main)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            
                            //MARK: - Header
                            HStack {
                                
                                                            Text("The International")
//                                Text(viewStore.serie.serie.league.name)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.bold, size: 18))
                                    .frame(width: geo.size.width, alignment: .center)
                            }
                            .overlay {
                                HStack {
                                    Button {
//                                        self.store.send(.closeButtonTapped)
                                        dismiss()
                                        //                                            self.store.send(.closeButtonTapped)
                                        //                                            viewStore.send(.closeButtonTapped)
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
                            .padding(.bottom, 5)
                            
                            
                            
                            TabView(selection: viewStore.binding(get: \.currentTab, send: { .tabSelected($0) } )) {
//                                if let serie = viewStore.serie {
                                ForEach(viewStore.serie!.sortedTournamentsByBegin.indices, id: \.self) { num in
                                        ScrollView {
                                            VStack(spacing: 25) {
                                                
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Matches")
                                                            .frame(width: geo.size.width / 3)
                                                            .font(.gilroy(.bold, size: 18))
                                                        
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                        
                                                        
                                                        
                                                        NavigationLink {
                                                            MatchesListView(store: Store(initialState: MatchesListDomain.State(), reducer: {
                                                                MatchesListDomain()
                                                            })).navigationBarBackButtonHidden()
                                                            
                                                        } label: {
                                                            
                                                            Image("Arrow", bundle: .main)
                                                                .resizable()
                                                                .renderingMode(.template)
                                                                .frame(width: 30, height: 25)
                                                                .foregroundStyle(.white)
                                                                .padding(.trailing, 20)
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        //                                                    Button {
                                                        //
                                                        //                                                        self.store.send(.matchListTapped)
                                                        //                                                    } label: {
                                                        //                                                        Image("Arrow", bundle: .main)
                                                        //                                                            .resizable()
                                                        //                                                            .renderingMode(.template)
                                                        //                                                            .frame(width: 30, height: 25)
                                                        //                                                            .foregroundStyle(.white)
                                                        //                                                            .padding(.trailing, 20)
                                                        //                                                    }
                                                    }
                                                    .frame(height: 35)
                                                    
                                                    
                                                    OngoingMatchListView(store: Store(initialState: OngoingMatchListDomain.State(), reducer: {
                                                        OngoingMatchListDomain()
                                                    }))
                                                    //                                                    .onTapGesture(perform: {
                                                    //                                                        self.store.send(.ongoingMatchTapped)
                                                    //                                                    })
                                                }
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Standings")
                                                            .frame(width: geo.size.width / 3)
                                                            .font(.gilroy(.bold, size: 18))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(height: 30)
                                                    
                                                    StandingsView(store: Store(initialState: StandingsDomain.State(), reducer: {
                                                        StandingsDomain()
                                                    }))
                                                }
                                                
                                                
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Partisipants")
                                                            .frame(width: geo.size.width / 3)
                                                            .font(.gilroy(.bold, size: 18))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(height: 30)
                                                    
                                                    //                                            if let teams = viewStore.serie.sortedTournamentsByBegin[num].teams {
                                                    
                                                    //                                                if !teams.isEmpty {
                                                    PartisipantsResketchView(store: Store(initialState: PartisipantsResketchDomain.State(teams: viewStore.serie!.sortedTournamentsByBegin[num].teams), reducer: {
                                                        PartisipantsResketchDomain()
                                                    }))
                                                    .padding(.bottom, 7)
                                                    //                                                    .onAppear {
                                                    //                                                        print(viewStore.serie.serie.league.name, "\(teams.count)")
                                                    //                                                    }
                                                    //                                                }
                                                    //                                            } else {
                                                    //                                                ScrollView {
                                                    //                                                    HStack {
                                                    //                                                        ForEach(0..<10, id: \.self) { num in
                                                    //                                                            VStack {
                                                    //                                                                Circle()
                                                    //                                                                    .foregroundStyle(Color("Gray", bundle: .main))
                                                    //                                                                    .frame(width: 70, height: 70)
                                                    //                                                                    .overlay {
                                                    //                                                                        Text("?")
                                                    //                                                                            .font(.gilroy(.regular, size: 25))
                                                    //                                                                            .foregroundStyle(.white)
                                                    //
                                                    //                                                                    }
                                                    //                                                                Text("TBD")
                                                    //                                                                    .font(.gilroy(.regular, size: 16))
                                                    //                                                                    .foregroundStyle(.white)
                                                    //                                                            }
                                                    //                                                        }
                                                    //                                                    }
                                                    //                                                }
                                                    //                                                .padding(.bottom, 7)
                                                    //                                            }
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        }
                                        .background(
                                            Color("Black", bundle: .main)
                                        )
                                        .contentShape(Rectangle()).gesture(DragGesture())
                                        .scrollIndicators(.never)
                                        .tag(num)
                                    }
//                                }
                                
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .ignoresSafeArea()
                            
                            
                            //MARK: - TabViewItems
                            ScrollView(.horizontal) {
                                
                                HStack(spacing: 0) {
                                    ForEach(viewStore.serie!.sortedTournamentsByBegin.indices, id: \.self) { num in
                                        VStack {
                                            Button {
                                                //                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                viewStore.send(.tabSelected(num))
                                                //                                                }
                                            } label: {
                                                switch viewStore.serie!.sortedTournamentsByBegin[num].tournament.name {
                                                case "Group Stage":
                                                    Text("Group Stage")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                    
                                                case "Playoffs":
                                                    Text("Playoffs")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                default:
                                                    Text("Phase \(num)")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 16))
                                                }
                                                
                                            }
                                            .padding(.bottom, 7)
                                            
                                            Rectangle()
                                                .frame(height: 2)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .opacity(viewStore.currentTab == num ? 1 : 0)
                                        }
                                        
                                        .frame(width:
                                                viewStore.serie!.tournaments.count == 2 ? geo.size.width / 2 :
                                                viewStore.serie!.tournaments.count == 1 ? geo.size.width / 1 :
                                                geo.size.width / 3)
                                        .frame(maxHeight: 50, alignment: .bottom)
                                        .overlay {
                                            Rectangle()
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .opacity(0.3)
                                                .mask {
                                                    LinearGradient(colors: [
                                                        .white,
                                                        .white.opacity(0.3),
                                                        .white.opacity(0.2),
                                                        .white.opacity(0.1)
                                                    ], startPoint: .bottom, endPoint: .top)
                                                }
                                                .opacity(viewStore.currentTab == num ? 1 : 0)
                                        }
                                    }
                                }
                                .animation(.easeInOut(duration: 0.3), value: viewStore.currentTab)
                            }
                            .scrollIndicators(.never)
                        }
                    }
                }
//            })

        }
    }
}

//#Preview {
//    DetailInfoResketchView(store: Store(initialState: DetailInfoResketchDomain.State(), reducer: {
//        DetailInfoResketchDomain()
//    }))
//}
