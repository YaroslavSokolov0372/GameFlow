//
//  PartisipantsListView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PartisipantsListDomain: Reducer {
    
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

struct PartisipantsListView: View {
    
    var store: StoreOf<PartisipantsListDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(0..<10, id: \.self) { _ in
                        NavigationLink {
                            
                            TeamDetailView(store: Store(initialState: TeamDetailDomain.State(), reducer: {
                                TeamDetailDomain()
                            })).navigationBarBackButtonHidden()
                        } label: {
                            VStack {
                                AsyncImage(url: URL(string: "https://cdn.pandascore.co/images/team/image/129041/190px_talent_gaming_logo.png")) { image in
                                    image
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .frame(width: 50, height: 50)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .foregroundStyle(Color("Gray", bundle: .main))
                                        )
                                } placeholder: {
                                        Circle()
                                            .foregroundStyle(Color("Gray", bundle: .main))
                                            .frame(width: 70, height: 70)
                                    
                                }
                                Text("Name")
                                    .font(.gilroy(.regular, size: 16))
                                    .foregroundStyle(.white)
                            }
                        }

                        
                    }
                }
                .padding(.horizontal, 11)
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    PartisipantsListView(store: Store(initialState: PartisipantsListDomain.State(), reducer: {
        PartisipantsListDomain()
    }))
}
