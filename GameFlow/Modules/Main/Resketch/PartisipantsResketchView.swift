//
//  PartisipantsResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PartisipantsResketchDomain: Reducer {
    
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

struct PartisipantsResketchView: View {
    
    var store: StoreOf<PartisipantsResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            //            NavigationView(content: {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    if let teams = viewStore.teams {
                        if teams.count > 0 {
                            ForEach(teams.sameLiquiTeam(viewStore.liquiTeams), id: \.self) { team in
                                NavigationLink {
                                    
                                    TeamDetailResketchView(store: Store(
                                        initialState: TeamDetailResketchDomain.State(team: viewStore.liquiTeams.getLiquiTeam(by: team.name)!), reducer: {
                                            TeamDetailResketchDomain()
                                        })).navigationBarBackButtonHidden()
                                    
                                } label: {
                                    
                                    VStack {
                                        if let imageURL = team.image_url {
                                            AsyncImage(url: URL(string: imageURL)) { image in
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
                                        Text(team.acronym == nil ? team.name : team.acronym!)
                                            .font(.gilroy(.regular, size: 16))
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                
                            }
                        } else {
//                            ScrollView {
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
//                            }
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
//    PartisipantsResketchView(store: Store(initialState: PartisipantsResketchDomain.State(), reducer: {
//        PartisipantsResketchDomain()
//    }))
//}
