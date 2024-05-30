//
//  BaseUIButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import UIKit

class BaseUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.2
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 1
//        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), cornerRadius: Constants.Design.cornerRadius).cgPath
//        
//    }
    
    
    
}
