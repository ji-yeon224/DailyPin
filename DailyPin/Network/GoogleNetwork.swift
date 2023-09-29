//
//  GoogleNetwork.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import Foundation
import Alamofire

final class GoogleNetwork {
    
    static let shared = GoogleNetwork()
    private init() { }
    
    
    func requestPlace(api: Router, completion: @escaping (Result<Place, AFError>) -> Void) {
//        let url = URL(string: "https://places.googleapis.com/v1/places:searchText")!
//        let headers: HTTPHeaders = [
//            "X-Goog-Api-Key": "\(APIKey.googleKey)",
//            "X-Goog-FieldMask": "places.id,places.location,places.displayName,places.formattedAddress"]
//        let query: [String: String] = ["textQuery" : "카페", "languageCode": "ko"]
//        AF.request(url, method: .post, parameters: query, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headers).responseDecodable(of: Place.self) { response in
//            switch response.result {
//            case .success(let data): completion(.success(data))
//            case .failure(let error): completion(.failure(error))
//            }
//        }
        
        AF.request(api).responseDecodable(of: Place.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
        }
        
    }
    
}
