//
//  UITextView+Extension.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/26.
//

import UIKit

extension UITextView {
    func setLineAndLetterSpacing(_ text: String){
        let style = NSMutableParagraphStyle()
        // 행간 세팅
        style.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        // 자간 세팅
        self.attributedText = attributedString
    }
}
