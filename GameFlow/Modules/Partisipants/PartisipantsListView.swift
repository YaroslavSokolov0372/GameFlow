//
//  PartisipantsListView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PartisipantsListDomain: Reducer {
    
    struct State: Equatable {
        let teams: [PandascoreTeam]?
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
    }
    
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

struct PartisipantsListView: View {
    
    var store: StoreOf<PartisipantsListDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            //            NavigationView(content: {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    if let teams = viewStore.teams {
                        if teams.count > 0 {
                            ForEach(teams.sameLiquiTeam(viewStore.liquiTeams), id: \.self) { team in
                                NavigationLink {
                                    
                                    TeamDetailView(store: Store(
                                        initialState: TeamDetailDomain.State(team: viewStore.liquiTeams.getLiquiTeam(by: team.name)!), reducer: {
                                            TeamDetailDomain()
                                        })).navigationBarBackButtonHidden()
                                    
                                } label: {
                                    
                                    VStack {
                                        if let liquiTeamImage = viewStore.liquiTeams.getLiquiTeam(by: team.name)?.imageURL {
                                            
                                            AsyncImage(url: URL(string: "https://liquipedia.net/\(liquiTeamImage)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .padding(15)
                                                    .background(
                                                        Circle()
                                                            .foregroundStyle(Color("Gray", bundle: .main))
                                                    )
                                            } placeholder: {
                                                Circle()
                                                    .foregroundStyle(Color("Gray", bundle: .main))
                                                    .frame(width: 70, height: 70)
                                                
                                            }
                                        } else {
                                            Circle()
                                                .foregroundStyle(Color("Gray", bundle: .main))
                                                .frame(width: 70, height: 70)
                                                .overlay {
                                                    Text("?")
                                                        .font(.gilroy(.regular, size: 25))
                                                        .foregroundStyle(.white)
                                                    
                                                }
                                        }
                                        Text(team.formattedName().acronym == nil ? team.formattedName().name : team.formattedName().acronym!)
                                            .font(.gilroy(.regular, size: 16))
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                
                            }
                        } else {
                                HStack(spacing: 20) {
                                    ForEach(0..<10, id: \.self) { num in
                                        VStack {
                                            Circle()
                                                .foregroundStyle(Color("Gray", bundle: .main))
                                                .frame(width: 70, height: 70)
                                                .overlay {
                                                    Text("?")
                                                        .font(.gilroy(.regular, size: 25))
                                                        .foregroundStyle(.white)
                                                    
                                                }
                                            Text("TBD")
                                                .font(.gilroy(.regular, size: 16))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 11)
                .onAppear {
                }
            }
            .scrollIndicators(.never)
        }
    }
}

//#Preview {
//    PartisipantsListView(store: Store(initialState: PartisipantsListDomain.State(), reducer: {
//        PartisipantsListDomain()
//    }))
//}
