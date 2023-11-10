//
//  TeamDetailView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TeamDetailDomain: Reducer {
    
    struct State: Equatable {
        
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

struct TeamDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    var store: StoreOf<TeamDetailDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                //MARK: - Header
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
//                                    self.store.send(.backButtonTapped)
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
                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/1669/600px_team_spirit_2021.png")) { image in
                                    image
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .scaledToFit()
                                        .frame(width: 170, height: 170)
                                    
                                } placeholder: {
                                    Circle()
                                        .foregroundStyle(Color("Gray", bundle: .main))
                                        .frame(width: 170, height: 170)
                                }
                                
                                Text("Team Spirit")
                                    .font(.gilroy(.bold, size: 25))
                                    .foregroundStyle(.white)
                                
                            }
                            .frame(width: geo.size.width, height: 250)
                            .padding(.bottom, 10)
                            
                            VStack(spacing: 30) {
                                ForEach(0..<5, id: \.self) { _ in
                                    PlayerCellView(store: Store(initialState: PlayerCellDomain.State(rotated: false), reducer: {
                                        PlayerCellDomain()
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

#Preview {
    TeamDetailView(store: Store(initialState: TeamDetailDomain.State(), reducer: {
        TeamDetailDomain()
    }))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        Color("Black", bundle: .main)
    )
}
