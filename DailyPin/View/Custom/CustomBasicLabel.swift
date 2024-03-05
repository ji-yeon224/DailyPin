//
//  CustomBasicLabel.swift
//  DailyPin
//
//  Created by 김지연 on 3/5/24.
//

import UIKit

final class CustomBasicLabel: UILabel {
    init(text: String, fontType: Font, color: UIColor? = Constants.Color.basicText, line: Int = 1) {
        super.init(frame: .zero)
        textColor = color
        numberOfLines = line
        font = fontType.fontStyle
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
