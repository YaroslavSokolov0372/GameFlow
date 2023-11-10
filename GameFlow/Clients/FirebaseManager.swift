//
//  FirebaseManager.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/11/2023.
//

import Foundation
import FirebaseFirestore





struct FireStoreManager {
    
    private let db = Firestore.firestore()
    
    
    func getLastDateStamp() async -> String? {
        
        let docRef = db.collection("DateStamps").document("LastFetch")
        
        var lastDateStamp: String? = nil
        
        
        
        
        do {
            let document = try await docRef.getDocument()
            
            if let data = document.data() {
                lastDateStamp = data["DateStamp"] as? String ?? ""
            } else {
                //throw an error
                print("failed with Data")
            }
            
        } catch {
            
            //Handle errors
            print(error)
        }
        
        print(lastDateStamp)
        return lastDateStamp
    }
    
    
    
    func shouldPandascoreReq() async -> Bool {
        
        
        if let lastStamp = await getLastDateStamp() {
            
            //Converting the time to current timeZone
            let stampAsDate = lastStamp.ISOfotmattedString()
            
            
//            let formatter = DateFormatter()
//            formatter.timeZone = .current
            Calendar.current.dateComponents([.hour, .minute], from: stampAsDate)
            
            
            
            
//            Calendar(identifier: .iso8601).dateBySetting(timeZone: .init(abbwreviation: "UTC")!, of: stampAsDate)
//            let stampInCurrentTimeZone = stampAsDate.ISO8601Format(.iso8601(timeZone: .autoupdatingCurrent))
//            let stampInCurrentTimeZone =
            
            
            //Current user's time
            let stringDate = Date.ISOStringFromDate(date: Date())
            let date = stringDate.ISOfotmattedString()
            
            //            let date = Date().ISO8601Format(.iso8601(timeZone: .autoupdatingCurrent))
//            let date = Calendar.current
//            date.timeZone = .init(abbreviation: "UTC")
                
//            let diffs = Calendar.current.dateComponents([.hour, .minute], from: stampAsDate, to: date)
            
//            let date = DateComponents(calendar: Calendar.current, timeZone: .init(abbreviation: "UTC"))
            
                
            
            //Check if fetching was less than in one hour

//            let difference = stampInCurrentTimeZone - date
            
            
            
        } else {
            return true
        }
        
        
        
        
        return true
    }
    

    
    
    
    
    func writeData() {
        db.collection("Series")
    }
    
    func getData() {
        
    }
}


extension Calendar {
    func dateBySetting(timeZone: TimeZone, of date: Date) -> Date? {
        var components = dateComponents(in: self.timeZone, from: date)
        components.timeZone = timeZone
        return self.date(from: components)
    }
}





//2023-11-09T18:07:47Z
//2023-11-09T18:08:21Z
//2023-11-09T18:10:14Z
//2023-11-09T19:12:33
//calendar: gregorian (fixed) locale: en_US time zone: GMT (fixed) firstWeekday: 1 minDaysInFirstWeek: 1 timeZone: GMT (fixed)
//2023-11-09T18:52:05.962Z
//2023-11-09T18:55:35Z
//2023-11-09T18:55:49Z
//2023-11-09T18:56:04Z
//hour: 0 minute: -55
//hour: 0 minute: 55
//hour: 0 minute: 55
//Optional(2023-11-09 20:20:58 +0000)
//Optional(2023-11-09 20:21:28 +0000)
