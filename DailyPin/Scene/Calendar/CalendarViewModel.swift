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
    private var dateSet: Set<String> = []
    
    func getRecords(date: String) {
        let data = recordRepository.filterItemByMonth(date)
        recordFilterByMonth.value = data
        
        dateSet.removeAll()
        data.forEach {
            dateSet.insert(DateFormatter.convertCalendarDate(date: $0.date))
            
        }
        
        dateSet.forEach {
            if let convert = DateFormatter.stringToDate(date: $0) {
                recordDateList.value.append(convert)
            }
        }
        
    }
    
    func filterDate(_ date: String) {
        recordFileterByDate.value.removeAll()
        recordFileterByDate.value.append(contentsOf: recordFilterByMonth.value.filter{
            DateFormatter.convertCalendarDate(date: $0.date) == date
        })
        
    }
    
    
    
}
