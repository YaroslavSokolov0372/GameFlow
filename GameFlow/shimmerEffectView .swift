//
//  shimmerEffectView .swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 13/10/2023.
//

import SwiftUI

struct shimmerEffectView_: View {
    @State var showEffect = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.searchBack)
                .frame(width: UIScreen.main.bounds.width / 1.16, height: 260)
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.gameListCellForeground)
//                .frame(width: UIScreen.main.bounds.width / 0.94, height: 150)
                .frame(width: UIScreen.main.bounds.width / 0.94, height: 120)
                .rotationEffect(.degrees(showEffect ? 360 : 0))
                .mask {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(lineWidth: 7)
                        .frame(width: UIScreen.main.bounds.width / 1.16, height: 253)
                        
                }
                .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: showEffect)
        }
        .onAppear(perform: {
            DispatchQueue.main.async {
                showEffect.toggle()
            }
        })
    }
}

#Preview {
    shimmerEffectView_()
}
