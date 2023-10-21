//
//  CalendarViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/11.
//

import Foundation

final class CalendarViewModel {
    
    private let recordRepository = RecordRepository()
    
    let recordFilterByMonth: Observable<[Record]> = Observable([])
    let recordDateList: Observable<[Date]> = Observable([])
    let recordFileterByDate: Observable<[Record]> = Observable([])
    private var dateSet: Set<Date> = []
    
    func getRecords(date: Date) {
        let data = recordRepository.filterItemByMonth(date)
        recordFilterByMonth.value = data
        
        let calendar = Calendar.current
        
        recordDateList.value.removeAll()
        dateSet.removeAll()
        data.forEach {
            dateSet.insert(calendar.startOfDay(for: $0.date))
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
