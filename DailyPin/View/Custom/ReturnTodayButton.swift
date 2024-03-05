//
//  ReturnTodayButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/23.
//

import UIKit

final class ReturnTodayButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setShadow()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle("today".localized(), for: .normal)
        setTitleColor(Constants.Color.basicText, for: .normal)
        titleLabel?.font = UIFont(name: "NanumGothic", size: 11)
        backgroundColor = Constants.Color.background
        layer.cornerRadius = Constants.Design.cornerRadius
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        clipsToBounds = false
    }
    
}
