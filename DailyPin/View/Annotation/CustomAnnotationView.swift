//
//  CustomAnnotationView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/08.
//

import Foundation
import UIKit

final class CustomAnnotationView: BaseAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero // 정면 빛
        view.layer.shadowRadius = 1 //그림자 퍼짐의 정도
        view.layer.shadowOpacity = 0.5 //그림자 불투명도 0~1사이
        view.clipsToBounds = false
        return view
    }()
    
    let imageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = Constants.Image.starImage
        view.contentMode = .scaleAspectFit
        view.tintColor = Constants.Color.pinColor
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }()
    
    
    
    
    override func configUI() {
        addSubview(backView)
        backView.addSubview(imageView)
        
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(5)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let _ = annotation as? CustomAnnotation else { return }
        setNeedsLayout()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: 40, height: 40)
        centerOffset = CGPoint(x: 0, y: bounds.size.width / 2)
    }
    
}
