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
     
        
        guard let languageCode = Locale.current.languageCode else { return }
        
        locale = Locale(identifier: languageCode)
        scrollEnabled = true
        
        headerHeight = 30
        appearance.headerMinimumDissolvedAlpha = 0.0
        
        
        appearance.headerDateFormat = "YYYY.MM"
        appearance.headerTitleColor = Constants.Color.basicText
        appearance.headerTitleFont = UIFont(name: "NanumGothicBold", size: 15)
        
        appearance.weekdayFont = UIFont(name: "NanumGothic", size: 12)
        appearance.weekdayTextColor = Constants.Color.basicText
        
        appearance.titleFont = UIFont(name: "NanumGothic", size: 13)
        appearance.todayColor = Constants.Color.subColor
        
        placeholderType = .none
        appearance.borderRadius = 1
        appearance.selectionColor = Constants.Color.mainColor
        
        calendarWeekdayView.weekdayLabels.first!.textColor = .systemRed
        calendarWeekdayView.weekdayLabels.last!.textColor = .systemBlue
        
        appearance.eventDefaultColor = Constants.Color.eventColor
        appearance.eventSelectionColor = Constants.Color.eventColor
        select(selectedDate)
        
    }
    
    
    
    
}
