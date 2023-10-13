//
//  TournamentViewCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct TournamentViewCellDomain: Reducer {
    
    struct State: Equatable {
         var serie: Serie
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



struct TournamentViewCell: View {
    
    var store: StoreOf<TournamentViewCellDomain>
    
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 60) {
                VStack {
                    Spacer()
                    
                    HStack(alignment: .top) {
                        
                        Image("Aegis", bundle: .main)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                
                                    .fill(.searchBack.opacity(0.8))
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(lineWidth: 1)
                                            .fill(.white)
                                    })
                            )
                            .padding(.trailing, 5)
                        
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                    Text(viewStore.serie.begin_at?.fotmattedString ?? "")
                                
                                if viewStore.serie.tournaments.count > 0 {
                                    
                                    if viewStore.serie.tournaments[0].tier != nil {
                                        if viewStore.serie.tournaments[0].tier == "unranked" {
                                            Text("UNR ·")
                                        } else {
                                            Text("\(viewStore.serie.tournaments[0].tier!.capitalizedSentence)-Tier ·")
                                                
                                        }
                                    }
                                    if viewStore.serie.tournaments[0].prizepool != nil {
                                        Text(viewStore.serie.tournaments[0].prizepool!)
                                    } else {
                                        Text("$$UNKW")
                                    }
                                }
                            }
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.8))
                            
                            Text(String(viewStore.serie.league.name) + " " + String(viewStore.serie.full_name))
                                .font(.system(size: 15))
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(20)
                }
                .frame(width: UIScreen.main.bounds.width / 1.16, height: 260, alignment: .leading)
                .background(
                    Image("Dota-2", bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 1.16, height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                )
                
                //            VStack {
                //                Spacer()
                //
                //                HStack(alignment: .top) {
                //
                //                    Image("Aegis", bundle: .main)
                //                        .resizable()
                //                        .frame(width: 50, height: 50)
                //                        .padding(10)
                //                        .background(
                //                            RoundedRectangle(cornerRadius: 10)
                //
                //                                .fill(.searchBack.opacity(0.8))
                //                                .overlay(content: {
                //                                    RoundedRectangle(cornerRadius: 10)
                //                                        .stroke(lineWidth: 1)
                //                                        .fill(.white)
                //                                })
                //                        )
                //                        .padding(.trailing, 10)
                //
                //
                //                    VStack(alignment: .leading) {
                //                        HStack {
                //                            Text("Oct. 12-29 *") +
                //                            Text(" S-Tier *") +
                //                            Text(" $2.98M")
                //                        }
                //                        .font(.system(size: 16))
                //                        .foregroundStyle(.white.opacity(0.8))
                //
                //                        Text("The International 2023")
                //                            .font(.system(size: 16))
                //                            .bold()
                //                            .foregroundStyle(.white)
                //                    }
                //                }
                //                .padding(20)
                //            }
                //            .frame(width: UIScreen.main.bounds.width / 1.1, height: 300, alignment: .leading)
                //            .background(
                //                Image("Dota-2", bundle: .main)
                //                    .resizable()
                //                //                .colorMultiply(.white.opacity(0.75))
                //                    .scaledToFill()
                //                    .frame(width: UIScreen.main.bounds.width / 1.1, height: 300)
                //                //                .offset(y: 10)
                //                    .clipShape(RoundedRectangle(cornerRadius: 10))
                //
                //
                //            )
            }
        }
    }
}

#Preview {
//    TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: Serie(begin_at: "Oct. 12", end_at: "Oct. 19", full_name: "The Int", id: 13, league_id: 123, modified_at: "", name: nil, season: "", slug: "", winner_type: "", year: 2023)), reducer: {
//        TournamentViewCellDomain()
//    }))
    
    MainView(store: Store(initialState: MainDomain.State(), reducer: {
        MainDomain()
    }))
    
}


extension String {
    
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}


extension String {
    var fotmattedString: String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: self)!
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM/dd"
        return newFormatter.string(from: date)
    }
}
