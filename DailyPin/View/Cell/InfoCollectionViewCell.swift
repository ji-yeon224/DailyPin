//
//  InfoCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/07.
//

import UIKit

final class InfoCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 10
        
        return view
    }()
    
    private let uiview = {
        let view = UIView()
        view.backgroundColor = Constants.Color.infoCellColor
        return view
    }()
    
    var titleLabel = CustomBasicLabel(text: "", fontType: Font.title2).then {
        $0.textAlignment = .left
    }
    
    
    var address = CustomBasicLabel(text: "", fontType: Font.body, color: Constants.Color.subTextColor)
    
    var dateLabel = CustomBasicLabel(text: "", fontType: Font.caption, color: Constants.Color.subTextColor)
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.layer.masksToBounds = false
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 0.1
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        contentView.layer.shadowRadius = 3
//        contentView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height), cornerRadius: 8).cgPath
//        
//    }
    
    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = Constants.Color.background
        contentView.layer.cornerRadius = 8
        contentView.addSubview(uiview)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(address)
        contentView.addSubview(dateLabel)
        //setShadow()
    }
    
    func setShadow() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .zero // 정면 빛
        contentView.layer.shadowRadius = 2 //그림자 퍼짐의 정도
        contentView.layer.shadowOpacity = 0.2 //그림자 불투명도 0~1사이
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
    }
    
    override func setConstraints() {
        
        uiview.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).offset(8)
            make.width.equalTo(5)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(uiview.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-20)
        }

        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-5)
            make.trailing.equalTo(contentView).offset(-10)
            make.leading.greaterThanOrEqualTo(uiview.snp.trailing).offset(50)
        }
        
        
        
    }
    
    
}


