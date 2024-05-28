//
//  FloatingType.swift
//  DailyPin
//
//  Created by 김지연 on 11/2/23.
//

import UIKit

enum FloatingType {
    case place
    case info(data: PlaceElement?)
    
    var viewcontroller: UIViewController {
        switch self {
        case .place:
            return PlaceListViewController()
        case let .info(info):
            return InfoViewController(placeData: info)
        }
    }
}
