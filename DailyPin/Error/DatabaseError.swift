//
//  DatabaseError.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation

enum DataBaseError: Error, LocalizedError {
    case createError
    case updateError
    case deleteError
    case searchError
    
    
    var errorDescription: String? {
        switch self {
        case .createError:
            return "Create Error"
        case .updateError:
            return "Update Error"
        case .deleteError:
            return "Delete Error"
        case .searchError:
            return "Search Error"
        }
    }
    
}
