//
//  CustomCalendarView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import UIKit
import FSCalendar

class CustomCalendarView: FSCalendar {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
     
        locale = Locale(identifier: "language".localized())
        scrollEnabled = true
        
        headerHeight = 55
        appearance.headerMinimumDissolvedAlpha = 0.0
        //appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
        appearance.headerDateFormat = "YYYY.MM"
        appearance.headerTitleColor = Constants.Color.basicText
        
        appearance.weekdayFont = .systemFont(ofSize: 12)
        appearance.weekdayTextColor = Constants.Color.basicText
        
        //appearance.titleTodayColor = .white
        appearance.titleFont = .systemFont(ofSize: 16)
        appearance.todayColor = Constants.Color.subColor
        
        placeholderType = .none
        appearance.borderRadius = 1
        appearance.selectionColor = Constants.Color.mainColor
        
        calendarWeekdayView.weekdayLabels.first!.textColor = .systemRed
        calendarWeekdayView.weekdayLabels.last!.textColor = .systemBlue
        
        
        select(selectedDate)
    }
    
    
    
    
}
