//
//  TeamDetailResketchVIew.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TeamDetailResketchDomain: Reducer {
    
    struct State: Equatable {
        
        let team: LiquipediaSerie.LiquipediaTeam
        
    }
    
    enum Action {
        case backButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            default: return .none
            }
        }
    }
}


struct TeamDetailResketchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var store: StoreOf<TeamDetailResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                
                ZStack {
                    
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            
                            Text("TEAM DETAILS")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 18))
                                .frame(width: geo.size.width, alignment: .center)
                        }
                        .overlay {
                            HStack {
                                Button {
                                    dismiss()
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
                        
                        ScrollView {
                            
                            VStack(spacing: 30) {
                                if viewStore.team.hasTeamImage {
                                    AsyncImage(url: URL(string: "https://liquipedia.net/\(viewStore.team.imageURL)")) { image in
                                        
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 170, height: 170)
                                        
                                    } placeholder: {
                                        Circle()
                                            .foregroundStyle(Color("Gray", bundle: .main))
                                            .frame(width: 170, height: 170)
                                    }
                                } else {
                                    
                                    Circle()
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                        .frame(width: 170, height: 170)
                                        .overlay {
                                            Text("?")
                                                .font(.gilroy(.semiBold, size: 30))
                                                .foregroundStyle(.white)
                                        }
                                }
                                
                                Text(viewStore.team.name)
                                    .font(.gilroy(.bold, size: 25))
                                    .foregroundStyle(.white)
                                
                            }
                            .frame(width: geo.size.width, height: 250)
                            .padding(.bottom, 10)
                            
                            VStack(spacing: 30) {
                                ForEach(viewStore.team.players, id: \.self) { player in
                                    PlayerViewResketch(store: Store(initialState: PlayerViewResketchDomain.State(
                                        rotated: false,
                                        liquiPlayer: player
                                    ), reducer: {
                                        PlayerViewResketchDomain()
                                    }))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    TeamDetailResketchView(store: Store(initialState: TeamDetailResketchDomain.State(), reducer: {
//        TeamDetailResketchDomain()
//    }))
//}