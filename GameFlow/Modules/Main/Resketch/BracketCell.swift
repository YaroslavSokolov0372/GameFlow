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
//                    Text("January 24, 2022, 9:00 AM")
                    Text(viewStore.bracket.begin_at ?? "TBD")
                        .font(.gilroy(.medium, size: 16))
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.bottom, 7)
                .frame(width: 290)
                
                
                
                ForEach(viewStore.bracket.opponents, id: \.self) { opponent in
                    HStack {
                        
                        AsyncImage(url: URL(string: opponent.opponent.image_url ?? "")) { image in
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
                        
                        Text(opponent.opponent.name)
                        
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
