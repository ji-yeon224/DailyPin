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
        case .emptyResult: return "검색 결과가 없습니다."
        case .wrongRequest: return "잘못된 요청입니다."
        case .invalidServer: return "네트워크 오류가 발생하였습니다."
        }
    }
}
