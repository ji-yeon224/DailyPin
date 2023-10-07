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
        view.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    var dateLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subTextColor
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 13)
        
        return view
    }()
    
    
    
    override func configureUI() {
        super.configureUI()
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = Constants.Design.cornerRadius
        contentView.layer.borderColor = Constants.Color.borderColor.cgColor
        
    }
    
    override func setConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.horizontalEdges.equalTo(contentView).offset(10)
            make.height.equalTo(contentView).multipliedBy(0.2)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(dateLabel.snp.bottom).offset(-10)
            make.bottom.greaterThanOrEqualTo(contentView).offset(10)
            
        }
        
    }
    
    
}


