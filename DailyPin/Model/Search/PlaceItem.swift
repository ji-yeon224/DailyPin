//
//  PlaceItem.swift
//  DailyPin
//
//  Created by 김지연 on 5/28/24.
//

import Foundation
// 도메인 엔티티
// vm 또는 vc에서 쓰는 PlaceElement를 대체해야 함
struct PlaceItem: ModelTypeProtocol {
    let id: String
    let address: String
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    let name: String
}

// 기존 Search 대체
struct PlaceItemList: ModelTypeProtocol {
    let item: [PlaceItem]
}
