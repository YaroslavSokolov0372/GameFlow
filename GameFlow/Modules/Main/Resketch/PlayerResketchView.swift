//
//  PlayerResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PlayerResketchDomain: Reducer {
    
    struct State: Equatable {
        let player: PandascoreTeam.PandascorePlayer
        let rotated: Bool
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

struct PlayerResketchView: View {
    
    var store: StoreOf<PlayerResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if viewStore.rotated {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .frame(width: 370, height: 75)
                    .overlay {
                        HStack {
                            HStack {
                                
                                Text("Position")
                                Text(viewStore.player.role ?? "?")
                                
                            }
                            .padding(10)
                            .foregroundStyle(.white)
                            .font(.gilroy(.bold, size: 15))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color("LightGray", bundle: .main))
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(Color("LightGray", bundle: .main))
                                            .blur(radius: 10)
                                            .opacity(0.55)
                                        
                                    })
                            )
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
//                                Text("Mira")
                                Text(viewStore.player.slug ?? "???")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                                
                                
//                                Text("Miroslaw Kolpakov")
                                Text((viewStore.player.first_name ?? "???") + " " + (viewStore.player.last_name  ?? "???"))
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.regular, size: 14))
                                
                            }
                            
                            if let imageURL = viewStore.player.image_url {
//                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/player/image/26725/mira_2023_team_spirit.png")) { image in
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(.white)
                                        )
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 75, height: 75)
                                        .foregroundStyle(.white)
                                }
                                .offset(y: -10)
                                
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 75, height: 75)
                                    .foregroundStyle(Color("Gray2", bundle: .main))
                                    .overlay(alignment: .center) {
                                        Text("?")
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.regular, size: 17))
                                    }
                                    .offset(y: -10)
                            }
                            
                            
                            
                            
                        }
                        //                    .font(.gilroy(.medium, size: 17))
                        .padding(.horizontal, 20)
                        
                    }
                
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .frame(width: 370, height: 75)
                    .overlay {
                        HStack {
                            if let imageURL = viewStore.player.image_url {
//                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/player/image/26725/mira_2023_team_spirit.png")) { image in
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(.white)
                                        )
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 75, height: 75)
                                        .foregroundStyle(.white)
                                }
                                .offset(y: -10)
                            } else {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 75, height: 75)
                                    .foregroundStyle(Color("Gray2", bundle: .main))
                                    .overlay(alignment: .center) {
                                        Text("?")
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.regular, size: 17))
                                    }
                                    .offset(y: -10)
                            }
                            
                            VStack(alignment: .leading) {
                                //                                Text("Mira")
                                Text(viewStore.player.name ?? "???")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                                
                                
                                //                                Text("Miroslaw Kolpakov")
                                Text((viewStore.player.first_name ?? "???") + " " +  (viewStore.player.last_name  ?? "???"))
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.regular, size: 14))
                                
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text("Position")
                                Text(viewStore.player.role ?? "?")
                                
                            }
                            .padding(10)
                            .foregroundStyle(.white)
                            .font(.gilroy(.bold, size: 15))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color("LightGray", bundle: .main))
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(Color("LightGray", bundle: .main))
                                            .blur(radius: 10)
                                            .opacity(0.55)
                                        
                                    })
                            )
                        }
                        //                    .font(.gilroy(.medium, size: 17))
                        .padding(.horizontal, 20)
                        
                    }
                
            }
        }
    }
}

//#Preview {
//    PlayerResketchView(store: Store(initialState: PlayerResketchDomain.State(rotated: false), reducer: {
//        PlayerResketchDomain()
//    }))
//}
