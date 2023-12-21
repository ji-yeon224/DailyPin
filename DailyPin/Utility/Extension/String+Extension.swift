//
//  String+Extension.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit


extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func setLineSpacing() -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let range = (self as NSString).range(of: self)
        let font = UIFont(name: "NanumGothic", size: 15) ?? .systemFont(ofSize: 15)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(.font, value: font, range: range)
//        memoTextView.attributedText = attrString
        return attrString
    }
    
    
}
