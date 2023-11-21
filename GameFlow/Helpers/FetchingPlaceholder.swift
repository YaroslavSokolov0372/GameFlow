//
//  FetchingPlaceholder.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 19/11/2023.
//

import Foundation
import SwiftUI


struct RedactCondition: ViewModifier {
    
    let condition: Bool
    
    
    func body(content: Content) -> some View {
        if condition {
            content
                .foregroundStyle(.white)
                .redacted(reason: .placeholder)
        } else {
            content
        }
    }
}


extension View {
    func redactCondition(condition: Bool) -> some View {
        modifier(RedactCondition(condition: condition))
    }
}
