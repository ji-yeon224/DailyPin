//
//  DividerView.swift
//  DailyPin
//
//  Created by 김지연 on 5/31/24.
//

import UIKit

final class DividerView: UIView {
    init(color: UIColor? = Constants.Color.borderColor) {
        super.init(frame: .zero)
        backgroundColor = color
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
