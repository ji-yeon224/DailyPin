//
//  CalendarViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/11.
//

import Foundation

final class CalendarViewModel {
    
    private let recordRepository = RecordRepository()
    
    let recordDateList: Observable<[Date]> = Observable([])
    let recordFileterByDate: Observable<[Record]> = Observable([])
    private var dateSet: Set<Date> = []
    
    func getRecords(date: Date) {
        recordDateList.value.removeAll()
        dateSet.removeAll()
        
        let dateList = recordRepository.filterItemByMonthOnlyDate(date)
        let calendar = Calendar.current
        
        dateList.forEach {
            dateSet.insert(calendar.startOfDay(for: $0))
        }
        recordDateList.value.append(contentsOf: dateSet)
        
    }
    
    func filterDate(_ date: Date) {
        let calendar = Calendar.current
        let selectedDate = calendar.startOfDay(for: date)
        recordFileterByDate.value.removeAll()
        recordFileterByDate.value.append(contentsOf: recordRepository.filterItemByDay(selectedDate))
    }
    
    
    
}
