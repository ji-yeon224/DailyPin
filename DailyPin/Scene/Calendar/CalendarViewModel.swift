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
    
    func getRecords(date: String) {
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
    
    func filterDate(_ date: String) {
        recordFileterByDate.value.removeAll()
        recordFileterByDate.value.append(contentsOf: recordFilterByMonth.value.filter{
            DateFormatter.convertCalendarDate(date: $0.date) == date
        })
        
    }
    
    
    
}
