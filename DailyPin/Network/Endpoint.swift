//
//  Endpoint.swift
//  DailyPin
//
//  Created by 김지연 on 5/28/24.
//

import Foundation
enum Endpoint {
    case place
    case geocoding
}

extension Endpoint {
    var url: URL {
        switch self {
        case .place:
            return URL(string: BaseURL.place + "/places:searchText")!
        case .geocoding:
            return URL(string: BaseURL.geocode + "/maps/api/geocode/json")!
        }
    }
}
