//
//  RecordData.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import Foundation

struct RecordData {
    var title: String
    var date: Date
    var memo: String?
    
    func toModel() -> Record {
        return Record(title: title, date: date, memo: memo)
    }
    
}
