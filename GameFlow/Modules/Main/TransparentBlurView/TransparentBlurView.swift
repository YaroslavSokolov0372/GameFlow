//
//  TransparentBlurView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 05/12/2023.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    
    var removeFilters = false
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}


#Preview {
    TransparentBlurView()
}
