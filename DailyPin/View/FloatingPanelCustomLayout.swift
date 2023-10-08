//
//  FloatingPanelCustomLayout.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import Foundation
import FloatingPanel

final class FloatingPanelCustomLayout: FloatingPanelLayout {
    
    
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
    
    
    
    
}
