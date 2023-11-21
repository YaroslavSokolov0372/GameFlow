//
//  SeriesType.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/11/2023.
//

import Foundation


enum SeriesType: String, CaseIterable {
    case ongoing = "ONGOING"
    case upcoming = "UPCOMING"
    case latest = "LATEST"
    
    var index: Int {
        return SeriesType.allCases.firstIndex(of: self) ?? 0
    }
    
    var count: Int {
        return SeriesType.allCases.count - 1
    }
}
