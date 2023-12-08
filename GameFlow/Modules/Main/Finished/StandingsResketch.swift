//
//  StandingsResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct StandingsResketchDomain: Reducer {
    
    struct State: Equatable {
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
        let standings: [PandascoreStandings]
        let newStandings: [Standings]
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

struct StandingsResketch: View {
    
    var store: StoreOf<StandingsResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            
            VStack(spacing: 0) {
                
                UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20)
                    .frame(width: 370, height: 40)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .overlay {
                        HStack {
                            Text("#")
                                .frame(maxWidth: 40)
                            
                            Text("Teams")
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("Matches")
                                .frame(width: 80)
                            
                            Text("Wins")
                                .frame(maxWidth: 40)
                        }
                        .padding(.horizontal, 10)
                        .frame(width: 370, height: 40)
                    }
                
                ForEach(viewStore.newStandings.sorted(by: { $0.wins < $1.wins }).indices, id: \.self) { num in
                    
                    Rectangle()
                        .frame(width: 370, height: 1, alignment: .center)
                        .foregroundStyle(Color("Gray", bundle: .main))
                    
                    HStack {
                        Text("\(num + 1).")
                            .frame(maxWidth: 40)
                        
                        HStack {
                                AsyncImage(url: URL(string: "https://liquipedia.net/\(viewStore.newStandings[num].imageURL)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 25, height: 25)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                }
                                .frame(width: 30)
                                
                            Text(viewStore.newStandings[num].name.teamFormatterName())
                            
                            Spacer()
                            
//                            Text("4-0-0")
//                                .frame(width: 80)
                            Text("\(viewStore.newStandings[num].wins)-\(viewStore.newStandings[num].looses)")
                                .frame(maxWidth: 40)
                            
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 370, height: 60)
                }
            }
                .font(.gilroy(.medium, size: 16))
                .foregroundStyle(.white)
        }
    }
}
