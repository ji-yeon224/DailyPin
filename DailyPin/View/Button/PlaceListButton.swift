//
//  PlaceListButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import Foundation

final class PlaceListButton: BaseUIButton {
    
    override func configure() {
        super.configure()
        backgroundColor = Constants.Color.background
        tintColor = Constants.Color.tintColor
        setImage(Constants.Image.placeList, for: .normal)
        layer.cornerRadius = Constants.Design.cornerRadius
    }
    
}
