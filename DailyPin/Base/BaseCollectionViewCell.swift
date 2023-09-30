//
//  BaseCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/30.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = Constants.Color.background
    }
    
    func setConstraints() {
        
    }
    
    
}
