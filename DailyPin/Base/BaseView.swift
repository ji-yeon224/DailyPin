//
//  BaseView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
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
    }
    
    func setConstraints() {
        
    }
    
}
