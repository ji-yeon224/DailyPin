//
//  Design.swift
//  DailyPin
//
//  Created by 김지연 on 3/5/24.
//

import UIKit

extension Constants {
    enum Design {
        static let cornerRadius: CGFloat = 10
        static let plainFont: String = "NanumGothic"
        static let boldFont: String = "NanumGothicBold"
        
        static let title1Font: UIFont = UIFont(name: "SFPro-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
        static let title2Font: UIFont = UIFont(name: "SFPro-Bold", size: 15) ?? .systemFont(ofSize: 15, weight: .bold)
        static let bodyBold: UIFont = UIFont(name: "SFPro-Bold", size: 13) ?? .systemFont(ofSize: 13, weight: .bold)
        static let bodyLarge: UIFont = UIFont(name: "SFPro-Regular", size: 22) ?? .systemFont(ofSize: 22)
        static let body: UIFont = UIFont(name: "SFPro-Regular", size: 13) ?? .systemFont(ofSize: 13)
        static let caption: UIFont = UIFont(name: "SFPro-Regular", size: 12) ?? .systemFont(ofSize: 12)
        static let caption2: UIFont = UIFont(name: "SFPro-Regular", size: 11) ?? .systemFont(ofSize: 11)
        
        static let nanumFont: UIFont = UIFont(name: "NanumGothic", size: 13) ?? .systemFont(ofSize: 13)
        static let nanumBold: UIFont = UIFont(name: "NanumGothicBold", size: 13) ?? .systemFont(ofSize: 13, weight: .bold)
        
    }

}
