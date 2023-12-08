//
//  HeaderView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 07/12/2023.
//

import SwiftUI

struct HeaderView: View {
    
    @Environment(\.dismiss) var dismiss
    let width: CGFloat
    let header: String
    
    var body: some View {
        HStack {
            
            Text(header)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.gilroy(.bold, size: 18))
                .frame(width: width, alignment: .center)
        }
        .overlay {
            HStack {
                Button {
                    
                    dismiss()
                    
                } label: {
                    Image("Arrow", bundle: .main)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(180))
                        .frame(width: 20, height: 17)
                }
                
                Spacer()
            }
            .padding(.leading, 20)
        }
        .padding(.vertical, 15)
        .padding(.bottom, 5)    }
}

#Preview {
    HeaderView(width: 400, header: "Hello")
        .background {
            Color("Black", bundle: .main)
        }
}
