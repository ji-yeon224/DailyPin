//
//  PlainLabel.swift
//  DailyPin
//
//  Created by 김지연 on 11/6/23.
//

import UIKit

final class PlainLabel: UILabel {
    
    init(size: CGFloat, lines: Int) {
        super.init(frame: .zero)
        font = UIFont(name: Constants.Design.plainFont, size: size)
        textColor = Constants.Color.basicText
        numberOfLines = lines
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

