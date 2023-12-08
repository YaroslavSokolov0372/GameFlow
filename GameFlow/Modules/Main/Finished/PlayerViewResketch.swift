//
//  PlayerViewResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PlayerViewResketchDomain: Reducer  {
    
    struct State: Equatable {
        let rotated: Bool
        let liquiPlayer: LiquipediaSerie.LiquipediaPlayer
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

struct PlayerViewResketch: View {
    
    var store: StoreOf<PlayerViewResketchDomain>
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
                                Text(viewStore.liquiPlayer.position)
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
                                Text(viewStore.liquiPlayer.nickname)
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                                
//
//                                Text("Miroslaw Kolpakov")
//                                    .foregroundStyle(.gray)
//                                    .font(.gilroy(.regular, size: 14))
                                
                            }
                            
                            AsyncImage(url: URL(string: "https://liquipedia.net/\(viewStore.liquiPlayer.flagURL)")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color("Gray2", bundle: .main))
                            }
//                            .offset(y: -10)
                        }
                        .padding(.horizontal, 20)
                    }
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .frame(width: 370, height: 75)
                    .overlay {
                        HStack {
                            
                            AsyncImage(url: URL(string: "https://liquipedia.net/\(viewStore.liquiPlayer.flagURL)")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color("Gray2", bundle: .main))
                            }
//                            .offset(y: -10)
                            
                            
                            
                            VStack(alignment: .trailing) {
                                Text(viewStore.liquiPlayer.nickname)
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                            }
                            
                            Spacer()
                            
                            
                            HStack {
                                Text("Position")
                                Text(viewStore.liquiPlayer.position)
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
                        .padding(.horizontal, 20)
                    }
            }
        }
    }
}

//#Preview {
//    PlayerViewResketch(store: Store(initialState: PlayerViewResketchDomain.State(rotated: false), reducer: {
//        PlayerViewResketchDomain()
//    }))
//}
