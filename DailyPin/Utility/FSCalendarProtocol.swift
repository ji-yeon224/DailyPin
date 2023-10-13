//
//  FSCalendarProtocol.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/11.
//

import Foundation

protocol FSCalendarProtocol: AnyObject {
    
    func returnButtonTapped()
    func moveCalendar(date: Date)
    func didSelectDate(date: Date)
    func numberOfEventsFor(date: Date) -> Int
    func calendarCurrentPageDidChange(date: String)
}
