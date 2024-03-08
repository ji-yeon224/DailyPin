//
//  BasicImageView.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit

final class BasicImageView: UIImageView {
    
    init(img: UIImage?, color: UIColor? = Constants.Color.mainColor) {
        super.init(frame: .zero)
        image = img
        tintColor = color
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
