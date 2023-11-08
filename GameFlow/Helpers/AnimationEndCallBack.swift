//
//  AnimationEndCallBack.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 02/11/2023.
//

import SwiftUI

struct AnimationState {
    var progress: CGFloat = 0
    var status: Bool = false
    
    mutating func startAnimation() {
        progress = 1.0
        status = true
    }
    
    mutating func reset() {
        progress = .zero
        status = false
        
        
    }
}

extension AnimationState: Equatable {
    
}


struct AnimationEndCallBack<Value: VectorArithmetic>: Animatable, ViewModifier {
    
    var animatableData: Value {
        
        didSet {
            checkIfAnimationFinished()
        }
    }
    
    var endValaue: Value
    var onEnd: () -> ()
    
    init(endValaue: Value, onEnd: @escaping () -> ()) {
        self.endValaue = endValaue
        self.animatableData = endValaue
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func checkIfAnimationFinished() {
//        print(animatableData)
        if animatableData == endValaue {
            DispatchQueue.main.async {
                onEnd()
            }
        }
    }
}
