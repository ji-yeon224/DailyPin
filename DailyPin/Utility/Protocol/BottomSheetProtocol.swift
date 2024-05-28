//
//  BottomSheetProtocol.swift
//  DailyPin
//
//  Created by 김지연 on 5/27/24.
//

import Foundation
protocol BottomSheetProtocol: AnyObject {
    func setLocation(data: PlaceItem)
    func deSelectAnnotation()
}
