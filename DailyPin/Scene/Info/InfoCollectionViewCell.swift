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
    
    
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    
    var address = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = Constants.Color.subTextColor
        view.numberOfLines = 0
        return view
    }()
    
    private var image = {
        var view = UIImageView()
        view.image = Constants.Image.mappinFill
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(address)
        contentView.addSubview(dateLabel)
        setShadow()
    }
    
    func setShadow() {
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .zero // 정면 빛
        contentView.layer.shadowRadius = 2 //그림자 퍼짐의 정도
        contentView.layer.shadowOpacity = 0.2 //그림자 불투명도 0~1사이
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
    }
    
    override func setConstraints() {
        
       
        
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
        }

        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-5)
            make.trailing.equalTo(contentView).offset(-10)
            make.leading.greaterThanOrEqualTo(contentView).offset(50)
        }
        
        
        
    }
    
    
}


