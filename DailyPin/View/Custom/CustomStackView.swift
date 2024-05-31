//
//  CustomStackView.swift
//  DailyPin
//
//  Created by 김지연 on 5/31/24.
//

import UIKit
final class CustomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fill
        spacing = 8
        isLayoutMarginsRelativeArrangement = true
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
