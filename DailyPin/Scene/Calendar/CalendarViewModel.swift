//
//  CalendarViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/11.
//

import Foundation
import RxSwift

final class CalendarViewModel {
    
    private let recordRepository = RecordRepository()
    let recordDates = PublishSubject<[Date]>()
    let recordItem = PublishSubject<[RecordSectionModel]>()
    
    func getRecords(date: Date) {
        var dateSet: Set<Date> = []
        print(date)
        let dateList = recordRepository.filterItemByMonthOnlyDate(date)
        let calendar = Calendar.current
        
        dateList.forEach {
            dateSet.insert(calendar.startOfDay(for: $0))
        }
        recordDates.onNext(Array(dateSet))
        
    }
    
    func filterDate(_ date: Date) {
        let calendar = Calendar.current
        let selectedDate = calendar.startOfDay(for: date)
        let item = recordRepository.filterItemByDay(selectedDate)
        recordItem.onNext([RecordSectionModel(section: 0, items: item)])
    }
    
    func convertToStruct(_ item: Place) -> PlaceItem {
        return item.toDomain()
    }
    
    
}
