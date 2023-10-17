//
//  SearchButton.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import UIKit

class SearchButton: BaseUIButton {
    
    override func configure() {
        super.configure()
        backgroundColor = Constants.Color.background
        setTitleColor(Constants.Color.placeholderColor, for: .normal)
        contentHorizontalAlignment = .leading
        setTitle("searchPlaceholder".localized(), for: .normal)
        titleLabel?.font = UIFont(name: "NanumGothic", size: 13)
        layer.cornerRadius = Constants.Design.cornerRadius
        
    }
    
    
}


