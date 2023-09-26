//
//  SearchTextField.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import UIKit

final class SearchTextField: UITextField {
    
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
        layer.cornerRadius = 10
        setShadow()
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1
    }
    
}
