//
//  Router.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case place(query: String, langCode: LangCode, location: (Double, Double))
    case geocoding
    
    private var baseURL: URL {
        switch self {
        case .place:
            return URL(string: "https://places.googleapis.com/v1/places:searchText")!
        case .geocoding:
            return URL(string: "")!
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .place:
            return ["X-Goog-Api-Key": "\(APIKey.googleKey)",
                    "X-Goog-FieldMask": "places.id,places.location,places.displayName,places.formattedAddress",
                    "Content-Type": "application/json"
            ]
        case .geocoding:
            return ["X-Goog-Api-Key": "\(APIKey.googleKey)"]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .place:
            return .post
        case .geocoding:
            return .get
        }
    }
    
    private var parameter: Codable {
        switch self {
        case .place(let query, let langCode, let location):
            return SearchParameter(textQuery: "\(query)",
                                   languageCode: "\(langCode.rawValue)",
                                   locationBias: LocationBias(circle: Center(center: DetailLocation(latitude: location.0, longitude: location.1))))
        case .geocoding:
            return ["": ""]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method

        let encoder = JSONEncoder()
        let paramters = parameter
        
        let jsonData: Data
        do {
            jsonData = try encoder.encode(paramters)
        } catch {
            throw InvalidError.invalidQuery
        }
        
        
        request.httpBody = jsonData
        
        return request
    }
    
}
