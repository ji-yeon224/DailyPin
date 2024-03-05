//
//  Font.swift
//  DailyPin
//
//  Created by 김지연 on 3/5/24.
//

import UIKit

enum Font {
    case title1
    case title2
    case bodyBold
    case body
    case caption
    case caption2
    case nanum
    
    var fontStyle: UIFont {
        switch self {
        case .title1:
            return Constants.Design.title1Font
        case .title2:
            return Constants.Design.title2Font
        case .bodyBold:
            return Constants.Design.bodyBold
        case .body:
            return Constants.Design.body
        case .caption:
            return Constants.Design.caption
        case .caption2:
            return Constants.Design.caption2
        case .nanum:
            return Constants.Design.nanumFont
        }
    }
}
