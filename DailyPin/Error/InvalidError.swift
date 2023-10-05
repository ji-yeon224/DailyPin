//
//  InputError.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/29.
//

import Foundation


enum InvalidError {
    case invalidInput
    case emptyQuery
    case invalidQuery
}

extension InvalidError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "유효하지 않은 입력 값입니다."
        case .emptyQuery:
            return "검색어를 입력하세요."
        case .invalidQuery:
            return "검색 요청에 문제가 발생하였습니다."
        }
    
    }
}
