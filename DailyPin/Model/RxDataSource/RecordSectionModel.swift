//
//  RecordSectionModel.swift
//  DailyPin
//
//  Created by 김지연 on 6/1/24.
//

import Foundation
import RxDataSources
struct RecordSectionModel: SectionModelType {
    typealias Item = Record
    var section: Int
    var items: [Record]
}

extension RecordSectionModel {
    init(original: RecordSectionModel, items: [Record]) {
        self = original
        self.items = items
    }
}
