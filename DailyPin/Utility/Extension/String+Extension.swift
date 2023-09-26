//
//  String+Extension.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import Foundation


extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}
