//
//  CalendarView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import Foundation
import UIKit
import FSCalendar

final class CalendarView: BaseView {
    
    lazy var currentPage = calendarView.currentPage
    weak var calendarDelegate: FSCalendarProtocol?
    
    lazy var calendarView = {
        let view = CustomCalendarView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // 이전 달로 이동 버튼
    private let prevButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        view.tintColor = Constants.Color.basicText
        return view
    }()
    
    // 다음 달로 이동 버튼
    private let nextButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = Constants.Color.basicText
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(calendarView)
        addSubview(prevButton)
        addSubview(nextButton)
        setAction()
    }
    
    override func setConstraints() {
        calendarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
            
        }
        
        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.leading.equalTo(calendarView.calendarHeaderView.snp.leading).inset(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.trailing.equalTo(calendarView.calendarHeaderView.snp.trailing).inset(100)
        }
    }
    
    private func setAction() {
        [prevButton, nextButton].forEach {
            $0.addTarget(self, action: #selector(moveMonthButtonDidTap(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func moveMonthButtonDidTap(sender: UIButton) {
        moveMonth(next: sender == nextButton)
    }
    
    // 달 이동 로직
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
    
}

extension CalendarView: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDelegate?.didSelectDate(date: date)
    }
   
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonth = DateFormatter.convertMonth(date: calendar.currentPage)
        calendarDelegate?.calendarCurrentPageDidChange(date: currentMonth)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        
        self.layoutIfNeeded()
    }
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .label
        }
    }
    
    // 표시되는 이벤트 갯수
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return calendarDelegate?.numberOfEventsFor() ?? 0
//    }
    
}
