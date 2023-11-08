//
//  PlayerView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PlayerCellDomain: Reducer {
    
    struct State: Equatable {
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

struct PlayerCellView: View {
    
    var store: StoreOf<PlayerCellDomain>
    
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
                                Text("4")
                                
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
                                Text("Mira")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                                
                                
                                Text("Miroslaw Kolpakov")
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.regular, size: 14))
                                
                            }
                            
                            
                            
                            AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/player/image/26725/mira_2023_team_spirit.png")) { image in
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
                            AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/player/image/26725/mira_2023_team_spirit.png")) { image in
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
                            
                            VStack(alignment: .leading) {
                                Text("Mira")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                                
                                
                                Text("Miroslaw Kolpakov")
                                    .foregroundStyle(.gray)
                                    .font(.gilroy(.regular, size: 14))
                                
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text("Position")
                                Text("4")
                                
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

#Preview {
    PlayerCellView(store: Store(initialState: PlayerCellDomain.State(rotated: false), reducer: {
        PlayerCellDomain()
    }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
        Color("Black", bundle: .main)
            .ignoresSafeArea()
    }
}
