//
//  Place.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import Foundation

// vm과 vc에 있는 Search 타입은 PlaceItemList로 대체
// Search는 없애고, 이거는 네트워크 통신 위한 타입임

struct SearchResDto: ResponseProtocol {
    typealias ResponseType = PlaceItemList
    
    var places: [PlaceElement]
    
    func toDomain() -> PlaceItemList {
        return .init(item: places.map { $0.toDomain() })
    }
}

struct PlaceElement: ResponseProtocol {
    typealias ResponseType = PlaceItem
    
    let id, formattedAddress: String
    let location: Location
    let displayName: DisplayName
    
    func toDomain() -> PlaceItem {
        return .init(id: id, address: formattedAddress, latitude: location.latitude, longitude: location.longitude, name: displayName.placeName)
    }
}

struct DisplayName: Decodable {
    let placeName: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "text"
    }
}

struct Location: Decodable {
    let latitude, longitude: Double
}
