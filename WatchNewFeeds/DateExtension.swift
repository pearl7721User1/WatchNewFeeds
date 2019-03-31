//
//  DateExtension.swift
//  WorkAround3
//
//  Created by SeoGiwon on 11/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

extension Date {
    func string(capitalized: Bool, withinAWeekFormat:String, otherDatesFormat:String) -> String {
        
        var dateString = ""
        if startOfToday().compare(self) == .orderedAscending {
            dateString = "today"
        } else if aWeekAgo().compare(self) == .orderedAscending {
            let format = DateFormatter()
            format.dateFormat = withinAWeekFormat
            dateString = format.string(from: self)
        } else {
            let format = DateFormatter()
            format.dateFormat = otherDatesFormat
            dateString = format.string(from: self)
        }
        
        return capitalized ? dateString.uppercased() : dateString
    }
    
    private func startOfToday() -> Date {
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = Calendar.current.date(from: components)
        return date!
        
    }
    
    private func aWeekAgo() -> Date {
        
        var date = Date()
        date.addTimeInterval(-3600 * 24 * 7)
        return date
    }
}
