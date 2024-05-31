//
//  CustomButton.swift
//  DailyPin
//
//  Created by 김지연 on 5/31/24.
//

import UIKit

final class CustomButton: UIButton {
    init(bgColor: UIColor?, img: UIImage? = nil, titleColor: UIColor? = .white, title: String, radius: CGFloat = 8) {
        super.init(frame: .zero)
        backgroundColor = bgColor
        setTitle(title, for: .normal)
        titleLabel?.font = Font.title2.fontStyle
        if let img = img {
            setImage(img, for: .normal)
        }
        
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = radius
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
