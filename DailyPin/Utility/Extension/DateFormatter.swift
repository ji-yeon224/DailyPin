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
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        return format
    }()
    
    static func today() -> String {
        return format.string(from: Date())
    }
    
    static func convertDate(date: Date) -> String {
        return format.string(from: date)
    }
}
