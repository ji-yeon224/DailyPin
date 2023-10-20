//
//  AddButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import UIKit

final class AddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = Constants.Color.background
        
        setImage(Constants.Image.plus, for: .normal)
        tintColor = Constants.Color.tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
    }
    
}
