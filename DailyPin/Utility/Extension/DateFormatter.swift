//
//  DateFormatter.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/06.
//

import Foundation


extension DateFormatter {
    
    static func convertToString(format: DateFormatterType, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}
