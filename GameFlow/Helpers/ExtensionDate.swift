//
//  ExtensionDate.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 21/10/2023.
//

import Foundation

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

extension Date {
    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.string(from: date).appending("Z")
    }
    
//    static func dateFromISOString(string: String) -> Date? {
//        let dateFormatter = DateFormatter()
////        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        
//        return dateFormatter.date(from: string)
//    }
}
