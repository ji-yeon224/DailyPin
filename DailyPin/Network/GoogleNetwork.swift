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
    
    
    func requestPlace(api: Router, completion: @escaping (Result<Search, NetworkError>) -> Void) {

        
        AF.request(api).responseDecodable(of: Search.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                let status = response.response?.statusCode ?? 500
                guard let error = NetworkError(rawValue: status) else { return }
                completion(.failure(error))
            }
        }
        
    }
    
    func requestGeocoder(api: Router, completion: @escaping (Result<Geocoding, NetworkError>) -> Void) {
        
        AF.request(api).responseDecodable(of: Geocoding.self) { response in
            
            switch response.result {
            case .success(let data): completion(.success(data)); //print(data)
            case .failure(_):
                let status = response.response?.statusCode ?? 500
                guard let error = NetworkError(rawValue: status) else { return }
                completion(.failure(error))
            }
        }
        
    }
    
    func requestGeocoder(lat: Double, lng: Double, completion: @escaping (Result<Geocoding, NetworkError>) -> Void) {
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDXn1mwRgnOnvqX_gs7eC-Sc5LJAplX9HQ&language=ko&latlng=\(lat),\(lng)"
        
        AF.request(url, method: .get).responseDecodable(of: Geocoding.self) { response in
            
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(_):
                let status = response.response?.statusCode ?? 500
                guard let error = NetworkError(rawValue: status) else { return }
                completion(.failure(error))
            }
            
            
        }
        
    }

    
}
