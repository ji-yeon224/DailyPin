//
//  FSCalendarProtocol.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/11.
//

import Foundation

protocol FSCalendarProtocol: AnyObject {
    
    func moveDate(date: Date)
    func numberOfEventsFor(date: Date) -> Int
    func calendarCurrentPageDidChange(date: Date)
}
