//
//  Place.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import Foundation

// MARK: - Place
struct Place: Decodable {
    let places: [PlaceElement]
}

// MARK: - PlaceElement
struct PlaceElement: Decodable {
    let id, formattedAddress: String
    let location: Location
    let displayName: DisplayName
}

// MARK: - DisplayName
struct DisplayName: Decodable {
    let text: String
    //let languageCode: LanguageCode
}

//enum LanguageCode: String, Decodable {
//    case en = "en"
//    case ko = "ko"
//}

// MARK: - Location
struct Location: Decodable {
    let latitude, longitude: Double
}
