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
    case noExistData
}

extension InvalidError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "invalid_invalidInput".localized()
        case .emptyQuery:
            return "invalid_emtyQuery".localized()
        case .invalidQuery:
            return "invalid_invalidQuery".localized()
        case .noExistData:
            return "invalid_noExistData".localized()
        }
    
    }
}
