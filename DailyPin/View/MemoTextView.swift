//
//  MemoTextView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/06.
//

import UIKit

class MemoTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isScrollEnabled = false
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.mainColor?.cgColor
        font = .systemFont(ofSize: 15)
        textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        tintColor = Constants.Color.mainColor
    }
    
}
