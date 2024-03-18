//
//  SelectImageModel.swift
//  DailyPin
//
//  Created by 김지연 on 3/15/24.
//

import Foundation
import RxDataSources
struct SelectImageModel: SectionModelType {
    typealias Item = SelectedImage
    var section: String
    var items: [SelectedImage]
}

extension SelectImageModel {
    init(original: SelectImageModel, items: [SelectedImage]) {
        self = original
        self.items = items
    }
}
