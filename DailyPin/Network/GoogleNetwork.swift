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
    
    
    func requestPlace(api: Router, completion: @escaping (Result<Place, NetworkError>) -> Void) {

        
        AF.request(api).responseDecodable(of: Place.self) { response in
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
