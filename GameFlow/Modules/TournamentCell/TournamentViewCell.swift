////
////  TournamentViewCell.swift
////  GameFlow
////
////  Created by Yaroslav Sokolov on 13/10/2023.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//
//struct TournamentViewCellDomain: Reducer {
//    
//    struct State: Equatable {
//         var serie: Serie
//    }
//    
//    enum Action {
//        case startedFetching
//    }
//    
//    var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .startedFetching:
//                return .none
//            }
//        }
//    }
//}
//
//
//
//struct TournamentViewCell: View {
//    
//    var store: StoreOf<TournamentViewCellDomain>
//    
//    
//    
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            
////            VStack(spacing: 60) {
////                                VStack {
////                                    Spacer()
////                
////                                    HStack() {
////                                        VStack(alignment: .center) {
////                                            if viewStore.serie.tournaments[0].tier != nil {
////                                                if viewStore.serie.tournaments[0].tier == "unranked" {
////                                                    Text("?")
////                                                        .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                                                        .font(.system(size: 30, design: .monospaced))
////                                                        
////                                                        .bold()
////                                                        .padding(10)
////                                                        .background(
////                                                            RoundedRectangle(cornerRadius: 10)
////                                                                .fill(.searchBack.opacity(0.8))
////                                                                .overlay(content: {
////                                                                    RoundedRectangle(cornerRadius: 10)
////                                                                        .stroke(lineWidth: 1)
////                                                                        .fill(Color("GameListCellForeground", bundle: .main))
////                                                                })
////                                                        )
////                                                    HStack {
////                                                        Text("Tier")
////                                                            .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                                                            .bold()
////                                                    }
////                                                } else {
////                                                    Text("\(viewStore.serie.tournaments[0].tier!.capitalizedSentence)")
////                                                        .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                                                        .font(.system(size: 30, design: .monospaced))
////                                                        
////                                                        .bold()
////                                                        .padding(10)
////                                                        .background(
////                                                            RoundedRectangle(cornerRadius: 10)
////                                                                .fill(.searchBack.opacity(0.8))
////                                                                .overlay(content: {
////                                                                    RoundedRectangle(cornerRadius: 10)
////                                                                        .stroke(lineWidth: 1)
////                                                                        .fill(Color("GameListCellForeground", bundle: .main))
////                                                                })
////                                                        )
////                                                    HStack {
////                                                        Text("Tier")
////                                                            .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                                                            .bold()
////                                                    }
////        
////                                                }
////                                            }
////                                        }
////                                        .frame(width: 40)
////                
////                
////                                        VStack(alignment: .leading) {
////                                            Text(String(viewStore.serie.league.name) + " " + String(viewStore.serie.full_name))
////                                                .font(.system(size: 18))
////                                                .bold()
////                                                .foregroundStyle(.white)
////                                                .frame(width: 265, height: 50, alignment: .leading)
////                                                .padding(.bottom, 5)
////                                            
////                                            HStack {
////                                                
////                                                Text(viewStore.serie.begin_at == nil ? viewStore.serie.begin_at!.fotmattedString() :  "") +
////                                                Text("-\(viewStore.serie.end_at == nil ? viewStore.serie.end_at!.fotmattedString() : "")")
////                
////                                                if viewStore.serie.tournaments.count > 0 {
////                                                    if viewStore.serie.tournaments[0].prizepool != nil {
////                                                        Text(viewStore.serie.tournaments[0].prizepool!)
////                                                    } else {
////                                                        Text("$UNKW")
////                                                    }
////                                                }
////                                            }
////                                            .font(.system(size: 15))
////                                            .foregroundStyle(.white.opacity(0.8))
////                
////
////                                        }
////                                        .frame(width: 270, height: 82, alignment: .leading)
////
////                                    }
////                                    .padding(20)
////                                    .frame(width: UIScreen.main.bounds.width / 1.17, alignment: .leading)
////                                }
////                                .frame(width: UIScreen.main.bounds.width / 1.17, height: 300, alignment: .leading)
////                                .background(
////                                    RoundedRectangle(cornerRadius: 10)
//////                                        .fill(Color("GameListCellBackColor", bundle: .main))
////                                        .fill(.searchBack)
////                                        .overlay {
////                                            VStack {
////                                                Image(DotaImages.allCases.randomElement()!.rawValue, bundle: .main)
////                                                    .resizable()
////                                                    .scaledToFill()
////                                                    .frame(width: UIScreen.main.bounds.width / 1.17, height: 230)
////                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
////                                                    .mask {
////                                                        LinearGradient(colors: [
////                                                            .white, .white, .white, .white.opacity(0.5), .white.opacity(0.1), .white.opacity(0.0),
////                                                        ], startPoint: .top, endPoint: .bottom)
////                                                    }
////                                                Spacer()
////                                            }
////                                    }
////                                )
////            }
//            VStack {
//                
//            }
//        }
//    }
//}
//
//#Preview {
////    TournamentViewCell(store: Store(initialState: TournamentViewCellDomain.State(serie: Serie(begin_at: "Oct. 12", end_at: "Oct. 19", full_name: "The Int", id: 13, league: League(id: 12321, image_url: nil, modified_at: "", name: "", slug: "", url: nil), league_id: 123, modified_at: "", name: nil, season: "", slug: "", tournaments: [], winner_type: "", year: 2023)), reducer: {
////        TournamentViewCellDomain()
////    }))
//    
//    MainView(store: Store(initialState: MainDomain.State(), reducer: {
//        MainDomain()
//    }))
//    
//}
//
//
//
//
//
//
//
////VStack {
////    Spacer()
////    
////    HStack() {
////        VStack(alignment: .center) {
////            Text("D")
////                .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                .font(.system(size: 30, design: .monospaced))
////                
////                .bold()
////                .padding(10)
////                .background(
////                    RoundedRectangle(cornerRadius: 10)
////                        .fill(.searchBack.opacity(0.8))
////                        .overlay(content: {
////                            RoundedRectangle(cornerRadius: 10)
////                                .stroke(lineWidth: 1)
////                                .fill(Color("GameListCellForeground", bundle: .main))
////                        })
////                )
////            HStack {
////                Text("Tier")
////                    .foregroundStyle(Color("GameListCellForeground", bundle: .main))
////                    .bold()
////            }
////        }
////        .frame(width: 40)
////        
////        
////        
////        VStack(alignment: .leading) {
////            
////            Text("The International so it pretty cool cool 2023")
////                .font(.system(size: 20))
////                .bold()
////                .foregroundStyle(.white)
////                .frame(width: 265, height: 50, alignment: .bottomLeading)
////                .padding(.bottom, 5)
////            HStack {
////                Text("Oct. 12-29 *") +
//////                                Text(" S-Tier *") +
////                Text(" $2.98M")
////            }
////            
////            .font(.system(size: 16))
////            .foregroundStyle(.white.opacity(0.8))
////            
////            
////        }
////        .frame(width: 270, height: 82, alignment: .leading)
////    }
////    .padding(20)
////    .frame(width: UIScreen.main.bounds.width / 1.17, alignment: .leading)
////}
////.frame(width: UIScreen.main.bounds.width / 1.17, height: 300, alignment: .leading)
////.background(
////    RoundedRectangle(cornerRadius: 10)
////        .fill(Color("GameListCellBackColor", bundle: .main))
////        .overlay {
////            VStack {
////                Image(DotaImages.allCases.randomElement()!.rawValue, bundle: .main)
////                    .resizable()
////                    .scaledToFill()
////                    .frame(width: UIScreen.main.bounds.width / 1.17, height: 230)
////                    .clipShape(RoundedRectangle(cornerRadius: 10))
////                    .mask {
////                        LinearGradient(colors: [
////                            .white, .white, .white, .white.opacity(0.5), .white.opacity(0.1), .white.opacity(0.0),
////                        ], startPoint: .top, endPoint: .bottom)
////                    }
////                Spacer()
////            }
////    }
////)
