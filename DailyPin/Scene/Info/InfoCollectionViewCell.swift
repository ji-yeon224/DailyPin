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
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.textAlignment = .left
        view.font = UIFont(name: "NanumGothicBold", size: 16)
        view.numberOfLines = 0
        return view
    }()
    
    var address = {
        let view = UILabel()
        view.font = UIFont(name: "NanumGothic", size: 13)
        view.textColor = Constants.Color.subTextColor
        view.numberOfLines = 0
        return view
    }()
    
    
    var dateLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subTextColor
        view.textAlignment = .left
        view.font = UIFont(name: "NanumGothic", size: 12)
        
        return view
    }()
    
    
    
    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = Constants.Color.background
        contentView.addSubview(uiview)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(address)
        contentView.addSubview(dateLabel)
        setShadow()
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


