//
//  FloatingPanelController+Extension.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/15.
//

import Foundation
import FloatingPanel

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 15.0
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        surfaceView.appearance = appearance
        
    }
}
