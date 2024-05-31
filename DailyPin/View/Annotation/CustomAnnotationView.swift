//
//  CustomAnnotationView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/08.
//

import Foundation
import UIKit

enum AnnotationState {
    case nomal
    case select
    case highlight
}

final class CustomAnnotationView: BaseAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = false
        return view
    }()
    
    let imageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "Annotation")//Constants.Image.starImage
        view.contentMode = .scaleAspectFit
//        view.tintColor = Constants.Color.pinColor
//        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }()
    
    func changePin(state: AnnotationState) {
        switch state {
        case .nomal:
            imageView.image = Constants.Image.annotation
        case .select:
            imageView.image = Constants.Image.selectAnnotation
        case .highlight:
            imageView.image = Constants.Image.highlightAnnotation
        }
//        if isSelected { // 선택
//            imageView.image = UIImage(named: "SelectAnnotation")
//        } else {
//            imageView.image = UIImage(named: "Annotation")
//        }
    }
    
    
    
    override func configUI() {
        addSubview(backView)
        backView.addSubview(imageView)
        
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(backView)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let _ = annotation as? CustomAnnotation else { return }
        setNeedsLayout()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: 35, height: 35)
        centerOffset = CGPoint(x: 0, y: 0)
//        shadow()
        
        
    }
    
    private func shadow() {
        backView.layer.cornerRadius = backView.frame.size.width / 2
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.4
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowRadius = 1
        backView.layer.shadowPath = UIBezierPath(arcCenter: CGPoint(x: backView.bounds.width/2, y: backView.bounds.height/2), radius: backView.bounds.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
    }
    
}
