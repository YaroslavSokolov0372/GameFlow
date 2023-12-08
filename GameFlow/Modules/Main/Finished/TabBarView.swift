//
//  TabBarView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 01/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TabBarDomain: Reducer {
    struct State: Equatable {
        @BindingState var offset: CGFloat = 0
    }
    
    enum Action {
        case scrollProgression(CGFloat)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

struct TabBarView: View {
    
    var store: StoreOf<TabBarDomain>
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            
            
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color("Black", bundle: .main))
                .frame(width: 350, height: 60)
                .overlay(content: {
                    HStack(spacing: 0) {
                        
                        Button {
                            
                        } label: {
                            Text("ONGOING")
                                .frame(width: 115)
                            
                        }
                        
                        
                        Button {
                            
                        } label: {
                            Text("UPCOMING")
                                .frame(width: 115)
                        }
                        
                        
                        Button {
                            
                        } label: {
                            Text("LATEST")
                                .frame(width: 115)
                            
                        }
                    }
                    
                    .foregroundStyle(.white)
                    .font(.gilroy(.bold, size: 16))
                    .background(
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color("Orange", bundle: .main))
                            .frame(width: 115, height: 50)
//                            .offset(x: 115)
                            .offset()
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundStyle(Color("Orange", bundle: .main))
                                    .blur(radius: 10)
                                    .opacity(0.6)
//                                    .offset(x: 115)
//                                    .offset(x: viewStore.offset * )
                                
                            })
                    )
                })
        }
        
    }
}

#Preview {
    TabBarView(store: Store(initialState: TabBarDomain.State(), reducer: {
        TabBarDomain()
    }))
}
