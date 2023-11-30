//
//  PlayerEmptyView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import SwiftUI

struct PlayerEmptyView: View {
    
    let rotated: Bool
    
    var body: some View {
        if rotated {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color("Gray", bundle: .main))
                .frame(width: 370, height: 75)
                .overlay {
                    HStack {
                        HStack {
                            Text("Position")
                            Text("?")
                        }
                        .padding(10)
                        .foregroundStyle(.white)
                        .font(.gilroy(.bold, size: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color("LightGray", bundle: .main))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color("LightGray", bundle: .main))
                                        .blur(radius: 10)
                                        .opacity(0.55)
                                    
                                })
                        )

                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("TBD")
                                .foregroundStyle(.white)
                                .font(.gilroy(.medium, size: 17))
                        }
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60, height: 60)
                                .foregroundStyle(Color("Gray2", bundle: .main))
                                .overlay(alignment: .center) {
                                    Text("?")
                                        .foregroundStyle(.white)
                                        .font(.gilroy(.medium, size: 17))
                                }
                    }
                    .padding(.horizontal, 20)
                }
        } else {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color("Gray", bundle: .main))
                .frame(width: 370, height: 75)
                .overlay {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color("Gray2", bundle: .main))
                            .overlay(alignment: .center) {
                                Text("?")
                                    .foregroundStyle(.white)
                                    .font(.gilroy(.medium, size: 17))
                            }
                        
                        VStack(alignment: .trailing) {
                            Text("TBD")
                                .foregroundStyle(.white)
                                .font(.gilroy(.medium, size: 17))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("Position")
                            Text("?")
                        }
                        .padding(10)
                        .foregroundStyle(.white)
                        .font(.gilroy(.bold, size: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color("LightGray", bundle: .main))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color("LightGray", bundle: .main))
                                        .blur(radius: 10)
                                        .opacity(0.55)
                                    
                                })
                        )
                    }
                    .padding(.horizontal, 20)
                }
        }

    }
}

#Preview {
    PlayerEmptyView(rotated: true)
}
