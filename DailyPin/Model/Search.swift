//
//  Place.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import Foundation

// MARK: - Place
struct Search: Decodable, Hashable {
    var places: [PlaceElement]
}

// MARK: - PlaceElement
struct PlaceElement: Decodable, Hashable {
    let id, formattedAddress: String
    let location: Location
    let displayName: DisplayName
    
   
}

// MARK: - DisplayName
struct DisplayName: Decodable, Hashable {
    let placeName: String
    //let languageCode: LanguageCode
    
    enum CodingKeys: String, CodingKey {
        case placeName = "text"
    }
}

//enum LanguageCode: String, Decodable {
//    case en = "en"
//    case ko = "ko"
//}

// MARK: - Location
struct Location: Decodable, Hashable {
    let latitude, longitude: Double
}
