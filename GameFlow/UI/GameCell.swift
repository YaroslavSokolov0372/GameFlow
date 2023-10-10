//
//  GameListCell.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 10/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct GameDomain: Reducer {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let game: Game
    }
    
    @Dependency(\.apiClient) var apiClient
    
    enum Action {
    }
    
    var body: some Reducer<State, Action> {
        
        
//        Scope(state: \.matches, action: /GameDetailInfoDomain.Action) {
//            GameDetailInfoDomain()
//        }
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

struct GameCell: View {
    
    let store: StoreOf<GameDomain>

    var body: some View {
        
        
        WithViewStore(self.store, observe: { $0}) { viewStore in
            
            VStack {
                HStack {
                    Text(viewStore.game.name)
                        .foregroundStyle(.white)
                        .bold()
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                Rectangle()
                    .fill(.white)
                    .frame(width: UIScreen.main.bounds.width / 1.05, height: 4)
                
                VStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { num in
                        NavigationLink {
                        } label: {
                            HStack {
                                Text("fjisdfjidsfjisdfisdfjsdfifjsdiffdjsifjsifsi")
                                    .foregroundStyle(.gameListCellForeground)
                                
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                    }
                }
                .padding(.vertical, 30)
                
            }
            .frame(width: UIScreen.main.bounds.width / 1.05 , height: 350, alignment: .bottom)
            .background(
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gameListCellBack)
                    

                    Image("Dota-2")
                        .resizable()
                        .colorMultiply(.white.opacity(0.75))
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 1.05, height: 140)
                        .offset(y: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                })
            .clipped()
            .overlay(alignment: .trailing) {
                NavigationLink {
                    
                } label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 90, height: 90)
                        .offset(x: -20, y: -55)
                }

            }
        }


    }
}

#Preview {
    GameCell(store: Store(initialState:
                            GameDomain.State(
                                id: .init(),
                            game: Game(current_version: nil,
                            id: 3,
                            name: "Dota-2",
                            slug: "Dota-2")),
                            reducer: {
        GameDomain()
    }))
                             
}


//                Image(game.name, bundle: .main)
//                    .resizable()
//                    .colorMultiply(.white.opacity(0.75))
//                    .aspectRatio(contentMode: .fit)
//                    .rotationEffect(.degrees(180), anchor: .center)
//                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0,z: 0))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
