//
//  Fonts.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 31/10/2023.
//

import Foundation
import SwiftUI


extension Font {
    
    enum Gilroy: String {
        case bold = "Gilroy-Bold"
        case light = "Gilroy-Light"
        case medium = "Gilroy-Medium"
        case regular = "Gilroy-Regular"
        case semiBold = "Gilroy-SemiBold"
        case thin = "Gilroy-Thin"
    }

    
    static func gilroy(_ fontType: Gilroy, size: CGFloat) -> Font {
        
        return .custom(fontType.rawValue, size: size)
    }
}
