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
        setTitle("  장소를 검색하세요.", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13)
        layer.cornerRadius = Constants.Design.cornerRadius
    }
    
    
}


