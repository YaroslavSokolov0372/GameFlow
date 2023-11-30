//
//  ExtensionString.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/10/2023.
//

import Foundation

extension String {
    
    func ISOfotmattedString() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: self)!
//        let newFormatter = DateFormatter()
//        newFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        return newFormatter.string(from: date).replacingOccurrences(of: "/", with: ".")
        return date
    }
}
