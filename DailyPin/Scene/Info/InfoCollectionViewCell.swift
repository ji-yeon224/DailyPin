//
//  InfoCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/07.
//

import UIKit

final class InfoCollectionViewCell: BaseCollectionViewCell {
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.numberOfLines = 1
        return view
    }()
    
    private var image = {
        var view = UIImageView()
        view.image = UIImage(systemName: "mappin.circle.fill")
        view.backgroundColor = .clear
        view.tintColor = Constants.Color.mainColor
        
        return view
    }()
    
    var dateLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subTextColor
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 12)
        
        return view
    }()
    
    
    
    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = Constants.Color.background
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        setShadow()
    }
    
    func setShadow() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .zero // 정면 빛
        contentView.layer.shadowRadius = 2 //그림자 퍼짐의 정도
        contentView.layer.shadowOpacity = 0.1 //그림자 불투명도 0~1사이
        contentView.clipsToBounds = false
    }
    
    override func setConstraints() {
        
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-5)
            make.trailing.equalTo(contentView).offset(-10)
            make.leading.greaterThanOrEqualTo(contentView).offset(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView).offset(-6)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
            
        }
        
    }
    
    
}


