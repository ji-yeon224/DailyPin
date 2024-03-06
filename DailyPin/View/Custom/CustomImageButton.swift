//
//  CustomImageButton.swift
//  DailyPin
//
//  Created by 김지연 on 3/5/24.
//

import UIKit

final class CustomImageButton: UIButton {
    
    init(img: UIImage?) {
        super.init(frame: .zero)
        setImage(img, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
