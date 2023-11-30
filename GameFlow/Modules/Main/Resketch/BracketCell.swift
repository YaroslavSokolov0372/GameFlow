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
        VStack(spacing: 5) {
            
            HStack {
                Text("January 24, 2022, 9:00 AM")
                    .font(.gilroy(.medium, size: 16))
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.bottom, 7)
            .frame(width: 290)
            
            HStack {
                
                AsyncImage(url: URL(string: "https://liquipedia.net/commons/images/thumb/a/a8/Project_Armor_lightmode.png/136px-Project_Armor_lightmode.png")) { image in
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
                
                Text("Team Secret")
                
                Spacer()
                
                Text("1")
            }
            .padding(.horizontal, 30)
            .foregroundStyle(.white)
            .frame(width: 290, height: 65)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
            )
            
            HStack {
                
                AsyncImage(url: URL(string: "https://liquipedia.net/commons/images/thumb/a/a8/Project_Armor_lightmode.png/136px-Project_Armor_lightmode.png")) { image in
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
                
                Text("Team Aster")
                
                Spacer()
                
                Text("1")
            }
            .padding(.horizontal, 30)
            .foregroundStyle(.white)
            .frame(width: 290, height: 65)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
            )
        }
        .font(.gilroy(.medium, size: 18))
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .padding()
//        .listRowSeparator(.hidden)
//        .listRowInsets(EdgeInsets())
        
    }
}

#Preview {
    BracketCell(store: Store(initialState: BracketCellDomain.State(), reducer: {
        BracketCellDomain()
    }))
}
