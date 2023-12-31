//
//  SelectAnnotationView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import Foundation
import UIKit

final class SelectAnnotationView: BaseAnnotationView {
    static let identifier = "SelectAnnotationView"
    
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
        view.image = Constants.Image.selectPin
        view.contentMode = .scaleAspectFit
        view.tintColor = Constants.Color.subColor
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
            make.size.equalTo(55)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let _ = annotation as? SelectAnnotation else { return }
        setNeedsLayout()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: 55, height: 55)
        centerOffset = CGPoint(x: 0, y: 0)
    }
    
}
