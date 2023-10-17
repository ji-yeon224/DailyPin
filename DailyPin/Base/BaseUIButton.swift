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
        setShadow()
    }
    
    private func setShadow() {
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    
}
