//
//  BracketCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 30/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct BracketCellDomain: Reducer {
    
    struct State: Equatable {
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
        let bracket: PandascoreBrackets
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


struct BracketCell: View {
    
    var store: StoreOf<BracketCellDomain>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 5) {
                
                HStack {
                    Text(viewStore.bracket.begin_at ?? "TBD")
                        .font(.gilroy(.medium, size: 16))
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.bottom, 7)
                .frame(width: 290)
                
                
                
                ForEach(viewStore.bracket.opponents, id: \.self) { opponent in
                    if viewStore.bracket.opponents.count == 2 {
                        HStack {
                            if let liquiTeam = viewStore.liquiTeams.getLiquiTeam(by: opponent.opponent.name) {
                                
                                AsyncImage(url: URL(string: "https://liquipedia.net/\(liquiTeam.imageURL)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                }
                                .frame(width: 30)
                                
                                Spacer()
                                
                                Text(liquiTeam.name)
                                    .font(.gilroy(.medium, size: 16))
                                
                                
                                Spacer()
                                
                                Text("\(viewStore.bracket.getOpponentsScore(opponent: opponent.opponent))")
                            }
                        }
                        .padding(.horizontal, 30)
                        .foregroundStyle(.white)
                        .frame(width: 290, height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color("Gray", bundle: .main))
                        )
                        
                    } else if viewStore.bracket.opponents.count == 1 {
                        
                        HStack {
                            if let liquiTeam = viewStore.liquiTeams.getLiquiTeam(by: opponent.opponent.name) {
                                
                                AsyncImage(url: URL(string: "https://liquipedia.net/\(liquiTeam.imageURL)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                }
                                .frame(width: 30)
                                
                                Spacer()
                                
                                Text(liquiTeam.name)
                                    .font(.gilroy(.medium, size: 16))
                                
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 30)
                        .foregroundStyle(.white)
                        .frame(width: 290, height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color("Gray", bundle: .main))
                        )
                        
                        HStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color("Gray2", bundle: .main))
                                .overlay {
                                    Text("?")
                                }
                                
                                .padding(.trailing, 60)
                            
                            
                            Text("TBD")
                                .font(.gilroy(.medium, size: 16))
                            
                            Spacer()
                            
                            
                            
                        }
                        .padding(.horizontal, 30)
                        .foregroundStyle(.white)
                        .frame(width: 290, height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color("Gray", bundle: .main))
                        )
                        
                    } else if viewStore.bracket.opponents.isEmpty {
                        
                        ForEach(0..<2, id: \.self) { _ in
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color("Gray2", bundle: .main))
                                    .overlay {
                                        Text("?")
                                    }
                                    
                                    .padding(.trailing, 60)
                                
                                
                                Text("TBD")
                                    .font(.gilroy(.medium, size: 16))
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, 30)
                            .foregroundStyle(.white)
                            .frame(width: 290, height: 65)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color("Gray", bundle: .main))
                            )
                        }
                    }

                }
            }
            .font(.gilroy(.medium, size: 18))
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding()
        }
    }
}

//#Preview {
//    BracketCell(store: Store(initialState: BracketCellDomain.State(), reducer: {
//        BracketCellDomain()
//    }))
//}
