//
//  TournamentResultCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct ResultsCellDomain: Reducer {
        
    
    struct State: Equatable {
        var tournament: Tournament
        var tournamentFinished: Bool {
            let currentDate = Date()
            if let endDate = tournament.end_at {
                let formatter = ISO8601DateFormatter()
                let formattedDate = formatter.date(from: endDate)!
                if  formattedDate.timeIntervalSinceNow.sign == .minus {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
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

struct ResultsCell: View {
    
//    var store: StoreOf<MainDomain>
    var store: StoreOf<ResultsCellDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack {
                Color.mainBack
                    .ignoresSafeArea()
                HStack {
                    HStack {
                        if viewStore.state.tournamentFinished {
                            HStack {
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .background(
                                        Circle()
                                            .foregroundStyle(.gameListCellForeground)
                                            .frame(width: 50, height: 50)
                                        
                                    )
                                VStack(alignment: .leading) {
                                    Text(viewStore.state.tournament.name)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 19))
                                        .bold()
                                    HStack {
                                        Text("Completed · ") +
                                        Text("Date: \(viewStore.state.tournament.begin_at!.fotmattedString() + " - " + viewStore.state.tournament.end_at!.fotmattedString())")
                                        
                                    }
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gameListCellForeground)
                                    
                                    
                                    
                                    
                                }

                                
                                
                                
                            }
                        } else {
                            
                            HStack {
                                Image(systemName: "clock")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .background(
                                        Circle()
                                            .foregroundStyle(.gray)
                                            .frame(width: 50, height: 50)
                                        
                                    )
                            }
                            VStack(alignment: .leading) {
                                Text(viewStore.state.tournament.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 19))
                                    .bold()
                                HStack {
                                    Text("Ongoing ·") +
                                    Text(" Date: \(viewStore.state.tournament.begin_at == nil ? "" : viewStore.tournament.end_at!.fotmattedString() + " - ")") +
                                    Text("\(viewStore.state.tournament.end_at == nil ? "TBD" : viewStore.tournament.end_at!.fotmattedString())")
                                    
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(.gameListCellForeground)
                                
                                
                                
                                
                            }
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("Arrow", bundle: .main)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(90))
                            .padding(.trailing, 10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ResultsCell(store: Store(initialState: ResultsCellDomain.State(tournament: Tournament(begin_at: "2023-10-29T22:00:00Z", end_at: "2023-10-29T22:00:00Z", has_bracket: false, id: 123, league_id: 123, live_supported: false, matches: [], modified_at: "", name: "Stage 1 - Group D", prizepool: "", serie_id: 123, slug: "", teams: [], tier: "", winner_type: "")), reducer: {
        ResultsCellDomain()
    }))
}
