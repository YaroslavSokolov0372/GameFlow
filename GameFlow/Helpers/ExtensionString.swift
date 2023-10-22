//
//  ExtensionString.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/10/2023.
//

import Foundation


extension String {
    
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}


extension String {
    func fotmattedString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: self)!
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM/dd"
        return newFormatter.string(from: date).replacingOccurrences(of: "/", with: ".")
    }
}
