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
    
    func requestData<T: ResponseProtocol>(api: Router, resultType: T.Type) async throws -> any ModelTypeProtocol {
        let request = AF.request(api)
        let datatask = request.serializingDecodable(T.self)
        
        switch await datatask.result {
        case let .success(response):
            return response.toDomain()
        case .failure(_):
            let status = await datatask.response.response?.statusCode ?? 500
            guard let error = NetworkError(rawValue: status) else {
                throw NetworkError.invalidServer
            }
            throw error
        }
    }
}
