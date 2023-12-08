//
//  SerieCellView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 31/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SerieCellDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var isFetching: Bool
        var serie: Serie
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

struct SerieCellView: View {
    var store: StoreOf<SerieCellDomain>
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack() {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 360, height: 270)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .overlay {
                        VStack {
                            Image("Image1", bundle: .main)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 330, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                                .redactCondition(condition: viewStore.isFetching)
//                                .foregroundStyle(.white)
//                                .redacted(reason: .placeholder)
                            
                            
                            Spacer()
                            
                        }
                        .frame(height: 350)
                    }
                
                VStack {
                    Text(viewStore.serie.fullName)
                        .foregroundStyle(.white)
                        .font(.gilroy(.bold, size: 20))
                        .padding(.horizontal)
                        .frame(width: 360, height: 55, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                    
//                        .redacted(reason: .placeholder)
                        .redactCondition(condition: viewStore.isFetching)
                    
                    
                    HStack {
                        
                        if let liquiInfo = viewStore.serie.liquipediaSerie {
                            
                            Text(liquiInfo.tier)
                                .font(.gilroy(.medium, size: 13))
                                .foregroundStyle(.white)
                                .padding(7)
                                .padding(.vertical, 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .foregroundStyle(Color("Orange", bundle: .main))
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color("Orange", bundle: .main))
                                                .blur(radius: 10)
                                                .opacity(0.5)
                                        })
                                )
                            
//                                .redacted(reason: .placeholder)
                                .redactCondition(condition: viewStore.isFetching)
                            

                            if liquiInfo.prizepool != "" {
                                Text(liquiInfo.prizepool)
                                    .font(.gilroy(.medium, size: 13))
                                    .foregroundStyle(.white)
                                    .padding(7)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 7)
                                            .foregroundStyle(Color("Orange", bundle: .main))
                                            .overlay(content: {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundStyle(Color("Orange", bundle: .main))
                                                    .blur(radius: 10)
                                                    .opacity(0.5)
                                            })
                                    )
                                
//                                    .redacted(reason: .placeholder)
                                    .redactCondition(condition: viewStore.isFetching)
                                
                            }
                        }
                        Spacer()
                        
                        Text(viewStore.serie.duration)
                            .font(.gilroy(.light, size: 12))
                            .foregroundStyle(.gray)
                        
//                            .redacted(reason: .placeholder)
                            .redactCondition(condition: viewStore.isFetching)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .frame(width: 360, height: 50)
                }
                .frame(width: 360, height: 280, alignment: .bottom)
                

                
            }
        }
    }
}

//#Preview {
//    SerieCellView(store: Store(initialState: SerieCellDomain.State(), reducer: {
//        SerieCellDomain()
//    }))
//}
