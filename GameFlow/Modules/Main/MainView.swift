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

    }
    
    enum Action {
    }
    
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {

        
        Reduce { state, action in
            switch action {
                
            default: return .none
                
            }
        }
    }
}

struct MainView: View {
    
    var store: StoreOf<MainDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                
                Color.mainBack
                    .ignoresSafeArea()
                
                VStack {
                    //MARK: - Ongoing Tournaments
                    HStack {
                        Text("Ongoing Tournaments")
                            .foregroundStyle(.gameListCellForeground)
                            .font(.title2)
                            .bold()
                        
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                        }
                    }
                    .padding(10)
                    .padding(.leading, 10)
                    .padding(.trailing, 15)
                    
                    //MARK: - Ongoing Tournaments List
                    
                    TournamentListView(store: Store(initialState: TournamentListDomain.State( apiFetchType: .ongoingTournaments), reducer: {
                        TournamentListDomain()
                    }))
                    
                    //MARK: - Upcoming Tournaments List
                    HStack {
                        Text("Upcoming Tournaments")
                            .foregroundStyle(.gameListCellForeground)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                        }
                    }
                    .padding(10)
                    .padding(.leading, 10)
//                    .padding(.trailing, 35)
                    .padding(.trailing, 15)
                    
                    
                    //MARK: - Upcoming TOurnamnets List
                    TournamentListView(store: Store(initialState: TournamentListDomain.State( apiFetchType: .upcommingTournaments), reducer: {
                        TournamentListDomain()
                    }))
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
}
