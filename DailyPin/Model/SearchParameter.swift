//
//  LocationBias.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import Foundation

struct SearchParameter: Codable {
    var textQuery: String
    var languageCode: String
    var locationBias: LocationBias
}
struct LocationBias: Codable {
    var circle: Center
}

struct Center: Codable {
    var center: DetailLocation
}

struct DetailLocation: Codable {
    var latitude: Double
    var longitude: Double
}
