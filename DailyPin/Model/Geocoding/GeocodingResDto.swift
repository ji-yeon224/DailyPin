//
//  Geocoding.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/14.
//

import Foundation

struct GeocodingResDto: ResponseProtocol {
    
    typealias ResponseType = PlaceItemList
    let results: [GeocodeData]
    let status: String
    func toDomain() -> PlaceItemList {
        return .init(item: results.map{ $0.toDomain() })
    }
}

struct GeocodeData: ResponseProtocol {
    typealias ResponseType = PlaceItem
    
    let addressComponents: [AddressComponent]
    let address: String
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case address = "formatted_address"
        case placeID = "place_id"
    }
    
    func toDomain() -> PlaceItem {
        var placeName: String = "\(addressComponents[0].longName)"
        if addressComponents.count > 2 {
            placeName = "\(addressComponents[1].longName) "+placeName
        }
        return .init(id: placeID, address: address, latitude: nil, longitude: nil, name: placeName)
    }
}


struct AddressComponent: Decodable {
    let longName: String
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }
}


