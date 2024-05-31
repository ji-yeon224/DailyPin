//
//  MemoTextView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/06.
//

import UIKit

class MemoTextView: UITextView {
    
    convenience init(mode: Mode) {
        self.init()
        configure()
        switch mode {
        case .read:
            isEditable = false
        case .edit:
            configBorder()
            isEditable = true
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isScrollEnabled = false
        textColor = Constants.Color.basicText
        backgroundColor = Constants.Color.background
        font = UIFont(name: "NanumGothic", size: 15)
        tintColor = Constants.Color.mainColor
    }
    
    private func configBorder() {
        
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.mainColor?.cgColor
        textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    }
    
}
