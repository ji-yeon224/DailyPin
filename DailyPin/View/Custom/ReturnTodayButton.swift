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
        setImage(Constants.Image.returnTodayButton, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
