//
//  FormattedName.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 08/12/2023.
//

import Foundation


extension String {
    
    func teamFormatted() -> Self {
        if self == "The dudley boyz" {
            return "The dudley boys".filter({ !$0.isWhitespace }).uppercased()
        } else {
            let regex = "\\[[^\\]]*\\]"
            return  self
                .replacingOccurrences(of: "Hustlers", with: "The dudley boys")
                .filter({ !$0.isWhitespace })
                .uppercased()
                .replacingOccurrences(of: "CIS2", with: "")
                .replacingOccurrences(of: regex, with: "", options: .regularExpression)
                .replacingOccurrences(of: "[0-9]+", with: "", options: .regularExpression)
        }
    }
    
    func teamFormatterName() -> Self {
        let regex = "\\[[^\\]]*\\]"
        if self == "The dudley boyz" {
            return "The dudley boys".filter({ !$0.isWhitespace }).uppercased()
        } else {
            return self
                .replacingOccurrences(of: regex, with: "", options: .regularExpression)
        }
    }
}
