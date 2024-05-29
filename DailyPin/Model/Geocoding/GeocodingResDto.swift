//
//  Geocoding.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/14.
//

import Foundation

struct GeocodingResDto: Decodable, Hashable {
    let results: [GeocodeData]
    let status: String
}

struct GeocodeData: Decodable, Hashable {
    let addressComponents: [AddressComponent]
    let address: String
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case address = "formatted_address"
        case placeID = "place_id"
    }
}


struct AddressComponent: Decodable, Hashable {
    let longName: String
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }
}


