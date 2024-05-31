//
//  BasicTextLabel.swift
//  DailyPin
//
//  Created by 김지연 on 5/31/24.
//

import UIKit

final class BasicTextLabel: UILabel {
    
    init(text: String = "", style: Font, color: UIColor? = nil, lines: Int = 1) {
        super.init(frame: .zero)
        self.text = text
        font = style.fontStyle
        textColor = color ?? Constants.Color.basicText
        numberOfLines = lines
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
