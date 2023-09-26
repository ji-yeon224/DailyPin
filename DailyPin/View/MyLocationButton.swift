//
//  MyLocationButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import UIKit

final class MyLocationButton: BaseUIButton {
    
    override func configure() {
        super.configure()
        let img = UIImage.SymbolConfiguration(pointSize: 18)
        setImage(UIImage(systemName: "location.fill", withConfiguration: img), for: .normal)
        backgroundColor = Constants.Color.mainColor
        tintColor = Constants.Color.tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
}
