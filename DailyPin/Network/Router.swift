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
    case geocoding(lat: Double, lng: Double)
    
    private var baseURL: URL {
        switch self {
        case .place:
            return Endpoint.place.url
        case .geocoding:
            return Endpoint.geocoding.url
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
            return ["Content-Type": "application/json"]
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
            
        case .geocoding: return ["":""]
        }
    }
    
    private var query: [String: String] {
        switch self {
        case .place:
            return ["":""]
        case .geocoding(let lat, let lng):
            let latlng = "\(lat),\(lng)"
            return ["key": "\(APIKey.googleKey)", "latlng":"\(latlng)", "language": "ko"]
        }
    }
    

    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        var request = URLRequest(url: urlComponent.url!)
        request.headers = header
        request.method = method
        
        if method == .get {
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        } else if method == .post {
            let encoder = JSONEncoder()
            let paramters = parameter
            let jsonData: Data
            do {
                jsonData = try encoder.encode(paramters)
            } catch {
                throw InvalidError.invalidQuery
            }
            request.httpBody = jsonData
        }
        
        return request
    }
    
}
