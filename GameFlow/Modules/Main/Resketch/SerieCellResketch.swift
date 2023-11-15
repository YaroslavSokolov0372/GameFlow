//
//  SerieCellResketch.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct SerieCellResketchDomain: Reducer {
    
    struct State: Equatable {
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

struct SerieCellResketch: View {
    
    var store: StoreOf<SerieCellResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack() {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 370, height: 280)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .overlay {
                        VStack {
                            Image("Image1", bundle: .main)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 340, height: 190)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                            Spacer()
                            
                        }
                        .frame(height: 350)
                    }
                
                VStack {
                    Text(viewStore.serie.fullName)
                        .foregroundStyle(.white)
                        .font(.gilroy(.bold, size: 20))
                        .padding(.horizontal)
                        .frame(width: 370, height: 55, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        if let tier = viewStore.serie.tier {
                            
                            Text(tier.capitalized + " Tier")
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
                            
                        }
                        
                        if let prizepool = viewStore.serie.prizepool {
                            //                        Text("$3M Prizepool")
                            Text(prizepool)
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
                        }
                        
                        
                        
//                        Text(viewStore.serie.tier)
//                            .font(.gilroy(.medium, size: 13))
//                            .foregroundStyle(.white)
//                            .padding(7)
//                            .padding(.vertical, 1)
//                            .background(
//                                RoundedRectangle(cornerRadius: 7)
//                                    .foregroundStyle(Color("Orange", bundle: .main))
//                                    .overlay(content: {
//                                        RoundedRectangle(cornerRadius: 5)
//                                            .foregroundStyle(Color("Orange", bundle: .main))
//                                            .blur(radius: 10)
//                                            .opacity(0.5)
//                                    })
//                            )
                        
                        Spacer()
                        
//                        Text("Oct 10 - Dec 19")
                        Text(viewStore.serie.duration)
                            .font(.gilroy(.light, size: 12))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .frame(width: 370, height: 50)
                }
                .frame(width: 370, height: 280, alignment: .bottom)
                
                //                .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.42, alignment: .top)
                //            }
                //            .frame(maxWidth: geo.size.width)
                //            }
                
            }
        }
    }
}

//#Preview {
//    SerieCellResketch(store: Store(initialState: SerieCellResketchDomain.State(), reducer: {
//        SerieCellResketchDomain()
//    }))
//}
