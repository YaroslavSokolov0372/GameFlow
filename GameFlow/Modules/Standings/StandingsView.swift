//
//  StandingsView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct StandingsDomain: Reducer {
    
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

struct StandingsView: View {
    
    var store: StoreOf<StandingsDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewstore in
            
            
                VStack(spacing: 0) {
                    
                    
                        UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20)
                            .frame(width: 370, height: 40)
                            .foregroundStyle(Color("Gray", bundle: .main))
                            .overlay {
                                HStack {
                                    Text("#")
                                        
                                        .frame(maxWidth: 40)
                                    
                                    Text("Teams")
                                        .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    Text("Matches")
                                        .frame(width: 80)
                                    
                                    Text("Wins")
                                        .frame(maxWidth: 40)
                                }
                                .padding(.horizontal, 10)
                                .frame(width: 370, height: 40)
                                
                                
                                
                            }
                    

                    
                    ForEach(0..<4, id: \.self) { num in
                        
                        Rectangle()
                            .frame(width: 370, height: 1, alignment: .center)
                            .foregroundStyle(Color("Gray", bundle: .main))
                        
                        HStack {
                            
                            Text("\(num + 1).")
                                .frame(maxWidth: 40)
                            
                            HStack {
                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129904/600px_entity_2021_lightmode.png")) { image in
                                    image
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .frame(width: 25, height: 25)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                }
                                .frame(width: 30)
                                
                                Text("Team Spirit")
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("4-0-0")
                                .frame(width: 80)
                            
                            Text("8-0")
                                .frame(maxWidth: 40)
                        }
                        .padding(.horizontal, 10)

                        .frame(width: 370, height: 60)
                    }
                }
                .font(.gilroy(.medium, size: 16))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    StandingsView(store: Store(initialState: StandingsDomain.State(), reducer: {
        StandingsDomain()
    }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
        Color("Black", bundle: .main)
            .ignoresSafeArea()
    }
    
}
