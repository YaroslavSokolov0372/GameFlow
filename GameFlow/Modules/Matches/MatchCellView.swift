//
//  MatchCellView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchCellDomain: Reducer {
    
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

struct MatchCellView: View {
    var store: StoreOf<MatchCellDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .frame(width: 370, height: 230)
                    
                VStack(spacing: 0) {
                    HStack {
                        
                        VStack(spacing: 0) {
                            AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129032/181px_e_dward_gaming_mobile_logo.png")) { image in
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color("Black", bundle: .main))
                            }
                            .frame(width: 120, height: 100)
                            
                            Text("Team Spirit")
                                .textCase(.uppercase)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 17))
                        }
                        
                        
                        Text("VS")
                            .foregroundStyle(.gray)
                            .font(.gilroy(.bold, size: 17))
                        
                        VStack(spacing: 0) {
                            AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129032/181px_e_dward_gaming_mobile_logo.png")) { image in
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color("Black", bundle: .main))
                            }
                            .frame(width: 130, height: 100)
                            
                            Text("Team Aster")
                                .textCase(.uppercase)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 17))
                        }
                    }
                    .padding(.bottom, 24)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(.gray)
                    
                    HStack() {
                        Text("Oct 19. 21:00")
                            .font(.gilroy(.medium, size: 16))
                            .foregroundStyle(.gray)
                      
                        Spacer()
                        
                        Text("Live")
                    }
                    .padding()
                    .frame(height: 60)
//                    .padding(10)
                }
                .frame(width: 360, height: 230, alignment: .bottom)
            }
        }
    }
}

#Preview {
    MatchCellView(store: Store(initialState: MatchCellDomain.State(), reducer: {
        MatchCellDomain()
    }))
}
