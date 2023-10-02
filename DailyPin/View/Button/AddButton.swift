//
//  AddButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import UIKit

final class AddButton: BaseUIButton {
    
    override func configure() {
        super.configure()
        backgroundColor = Constants.Color.mainColor
        layer.cornerRadius = Constants.Design.cornerRadius
        setImage(UIImage(systemName: "plus"), for: .normal)
        tintColor = Constants.Color.tintColor
        
    }
    
}
