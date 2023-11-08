//
//  MatchDetailView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchDetailDomain: Reducer {
    
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



struct MatchDetailView: View {
    
    var store: StoreOf<MatchDetailDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Text("MATCH DETAILS")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .font(.gilroy(.bold, size: 18))
                            .frame(width: geo.size.width, alignment: .center)
                    }
                    .overlay {
                        HStack {
                            Button {
                                
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
                    
                    
                    ScrollView(.vertical) {
                            
                        Text("You can use sideways to get better view of the team")
                            .multilineTextAlignment(.center)
                            .font(.gilroy(.regular, size: 15))
                            .frame(width: 240, height: 40)
                            .foregroundStyle(.gray)
                        
                        HStack {
                            VStack(spacing: 20) {
                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129808/lava_allmode.png")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 80, height: 80)
                                }
                                Text("LAVA")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.bold, size: 17))
                            }
                            
                            Text("VS")
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 17))
                                .frame(width: geo.size.width * 0.25)
                                .offset(y: -15)
                            
                            
                            VStack(spacing: 20) {
                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129808/lava_allmode.png")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 80, height: 80)
                                }
                                Text("LAVA")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.bold, size: 17))
                            }
                        }
                        .padding(.vertical, 20)
                        
                        HStack {
                            VStack(spacing: 20) {
                                ForEach(0..<5, id: \.self) { num in
                                    PlayerCellView(store: Store(initialState: PlayerCellDomain.State(rotated: true), reducer: {
                                        PlayerCellDomain()
                                    }))
                                }
                            }
                            .frame(width: geo.size.width * 0.2)
                            .offset(x: -40)
                            
                            Spacer()
                            
                            VStack(spacing: 20) {
                                ForEach(0..<5, id: \.self) { num in
                                    PlayerCellView(store: Store(initialState: PlayerCellDomain.State(rotated: false), reducer: {
                                        PlayerCellDomain()
                                    }))
                                }
                            }
                            .frame(width: geo.size.width * 0.2)
                            .offset(x: 40)
                        }
                        
                        
                        VStack(spacing: 15) {
                            HStack {
                                Text("Twich Stream List")
                                    .font(.gilroy(.bold, size: 17))
                                    .foregroundStyle(.white)
                            }
                            
                            ForEach(0..<3, id: \.self) { num in
                                
                                HStack(spacing: 0){
                                    Image("Twitch", bundle: .main)
                                    
                                    Text("EN")
                                        .font(.gilroy(.bold, size: 15))
                                        .foregroundStyle(.white)
                                        .offset(x: -10)
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Image("Arrow", bundle: .main)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .offset(x: -14)
                                .frame(width: geo.size.width * 0.95)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                }
                            }
                        }
                        .padding(.top, 15)
                    }
                    .scrollIndicators(.never)

                    
                    
                    
                }
            }
        }
    }
}

#Preview {
    MatchDetailView(store: Store(initialState: MatchDetailDomain.State(), reducer: {
        MatchDetailDomain()
    }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        Color("Black", bundle: .main)
            .ignoresSafeArea()
    )
}
