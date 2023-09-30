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

        
        AF.request(api).responseDecodable(of: Place.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
        }
        
    }
    
}
