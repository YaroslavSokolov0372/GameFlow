//
//  MatchType.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 28/11/2023.
//

import Foundation

enum MatchType: String, CaseIterable {
    case ongoing = "ONGOING"
    case finished = "FINISHED"
    
    var count: Int {
        return Self.allCases.count - 1
    }
    
    var index: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
}
