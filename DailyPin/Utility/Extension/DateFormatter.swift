//
//  DateFormatter.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/06.
//

import Foundation


extension DateFormatter {
    
    
    
    static let format = {
        let format = DateFormatter()
        format.locale = Locale(identifier: Locale.current.languageCode ?? "ko_KR")
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        return format
    }()
    
    static let monthFormat = {
        let format = DateFormatter()
        format.locale = Locale(identifier: Locale.current.languageCode ?? "ko_KR")
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        format.dateFormat = "yyyy.MM"
        return format
    }()
    
    static let formatDate = {
        let form = DateFormatter()
        format.locale = Locale(identifier: Locale.current.languageCode ?? "ko_KR")
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        form.dateFormat = "yyyy-MM-dd"
        return form
        
    }()
    
    
    static func convertDate(date: Date) -> String {
        return format.string(from: date)
    }
    
    static func convertMonth(date: Date) -> String {
        return monthFormat.string(from: date)
    }
    
    static func convertCalendarDate(date: Date) -> String {
        return formatDate.string(from: date)
    }
    
    static func stringToDate(date: String) -> Date? {
        return formatDate.date(from: date) ?? nil
    }
}
