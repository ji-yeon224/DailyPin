//
//  Record.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/06.
//

import Foundation
import RealmSwift

final class Record: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var memo: String?
    @Persisted(originProperty: "recordList") var placeInfo: LinkingObjects<Place>
    
    
    convenience init(title: String, date: Date, memo: String? = nil) {
        self.init()
        self.title = title
        self.date = date
        self.memo = memo
    }
    
    func toDomain() -> RecordData {
        return RecordData(title: title, date: date, memo: memo)
    }
}
