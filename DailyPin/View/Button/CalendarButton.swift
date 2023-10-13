//
//  CalendarButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import UIKit

final class CalendarButton: BaseUIButton {
    
    
    override func configure() {
        super.configure()
        backgroundColor = Constants.Color.mainColor
        layer.cornerRadius = Constants.Design.cornerRadius
        setImage(Constants.Image.calendar, for: .normal)
        tintColor = Constants.Color.tintColor
        
    }
    
}
