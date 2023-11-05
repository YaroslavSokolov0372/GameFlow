//
//  OffsetReader.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 01/11/2023.
//

import Foundation
import SwiftUI

struct TabViewScrollReader: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    
}

extension View {
    @ViewBuilder
    func offsetX(_ addObserver: Bool = false, competion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { geo in
                    var size = geo.frame(in: .global)
                    Color.clear
                        .preference(key: TabViewScrollReader.self, value: size)
                        .onPreferenceChange(TabViewScrollReader.self, perform: { value in
                            competion(value)
                        })
                }
            }
    }
}
