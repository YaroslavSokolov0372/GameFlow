//
//  SerieLoadingCellView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 19/11/2023.
//

import SwiftUI

struct SerieLoadingCellView: View {
    
    @State var active = false
    
    var body: some View {
        ZStack {
            Color("Black", bundle: .main)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 360, height: 270)
                .foregroundStyle(Color("Gray", bundle: .main))
                .overlay {
                    VStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 330, height: 180)
                            
//                            .clipShape(RoundedRectangle(cornerRadius: 25))
//                            .overlay(content: {
//                                RoundedRectangle(cornerRadius: 25)
//                                    .foregroundStyle(Color("LightGray", bundle: .main))
//                                    .foregroundStyle(.white)
//                                    .frame(width: 330, height: 180)
//                                    .mask {
//                                        RoundedRectangle(cornerRadius: 25)
//                                            
//                                            .frame(width: 60, height: 400)
//                                            .rotationEffect(.degrees(45))
//                                            
//                                            .offset(x: -290)
//                                            .offset(x: active ? 700 : 0)
//                                    }
//                            })
                            
                        
                        Spacer()
                        
                    }
                    .frame(height: 350)
                }
            
            VStack {
                VStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 330, height: 27, alignment: .topLeading)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 330, height: 27, alignment: .topLeading)

                }
                .frame(width: 360, height: 55, alignment: .top)
                HStack {
                 
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 50, height: 30)
                    
                    
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 50, height: 30)
                        .redacted(reason: .placeholder)
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 70, height: 30)
                }
                .padding(.bottom, 10)
                .frame(width: 330, height: 50)
            }
            
            
            
            .frame(width: 370, height: 280, alignment: .bottom)
        }
        .foregroundStyle(Color("LightGray", bundle: .main))
        .onAppear(perform: {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                active.toggle()
            }
        })

    }
    
    
    
//    struct Shimmer: View {
//        
//        @Binding var active: Bool
//        let width: CGFloat
//        let height: CGFloat
//        
//        var body: some View {
//            RoundedRectangle(cornerRadius: 25)
//                .foregroundStyle(.white)
//                .frame(width: width, height: height)
//                .mask {
//                    RoundedRectangle(cornerRadius: 25)
//                        
//                        .frame(width: 60, height: 400)
//                        .rotationEffect(.degrees(45))
//                        
//                        .offset(x: -290)
//                        .offset(x: active ? 700 : 0)
//                }
//        }
//    }
}

#Preview {
    SerieLoadingCellView()
}




