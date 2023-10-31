//
//  SerieCellView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 31/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SerieCellDomain: Reducer {
    struct State {
        
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
        ZStack() {
//        GeometryReader { geo in
//            ZStack {
                RoundedRectangle(cornerRadius: 25)
//                    .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.35)
                .frame(width: 350, height: 280)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .overlay {
                        VStack {
                            Image("Image1", bundle: .main)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            //                        .frame(width: geo.size.width * 0.84 , height: geo.size.height * 0.24)
                                .frame(width: 310, height: 190)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                            Spacer()
                            
                        }
                        .frame(height: 350)
                    }
                
                VStack {
                    Text("dksoadksoa")
                        .foregroundStyle(.white)
                        .font(.gilroy(.bold, size: 20))
                        .padding(.horizontal)
                        .frame(width: 350, height: 55, alignment: .topLeading)
//                        .frame(width: geo.size.width * 0.83, height: geo.size.height * 0.07, alignment: .topLeading)
                    HStack {
                        Text("$3M Prizepool")
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
                        
                        Spacer()
                        Text("Oct 10 - Dec 19")
                            .font(.gilroy(.light, size: 12))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .frame(width: 350, height: 50)
                }
                
                .frame(width: 350, height: 280, alignment: .bottom)

//                .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.42, alignment: .top)
//            }
//            .frame(maxWidth: geo.size.width)
//            }
            
        }
    }
}

#Preview {
    SerieCellView(store: Store(initialState: SerieCellDomain.State(), reducer: {
        SerieCellDomain()
    }))
}
