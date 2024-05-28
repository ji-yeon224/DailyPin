//
//  PlaceItem.swift
//  DailyPin
//
//  Created by 김지연 on 5/28/24.
//

import Foundation
struct PlaceItem: ModelTypeProtocol {
    let id: String
    let address: String
    let latitude: Double
    let longitude: Double
    let name: String
}
