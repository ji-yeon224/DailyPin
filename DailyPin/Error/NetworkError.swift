//
//  NetworkError.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/30.
//

import Foundation

enum NetworkError: Int, Error {
    
    case emptyResult = 200 // 요청 성공했지만 빈 값이 전달 된 경우
    case wrongRequest = 400
    case invalidServer = 500
    
    
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyResult: return "network_emptyResult".localized()
        case .wrongRequest: return "network_wrongREquest".localized()
        case .invalidServer: return "network_invalidServer".localized()
        }
    }
}
