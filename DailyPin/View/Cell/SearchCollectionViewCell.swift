//
//  SearchCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/30.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var title = BasicTextLabel(style: .bodyBold)
    var address = BasicTextLabel(style: .caption2, lines: 0)
    
    private var image = {
        var view = UIImageView()
        view.image = Constants.Image.mappinFill
        view.backgroundColor = .clear
        view.tintColor = Constants.Color.mainColor
        
        return view
    }()
    
    
    
    
    override func configureUI() {
        super.configureUI()
        contentView.addSubview(title)
        contentView.addSubview(image)
        contentView.addSubview(address)
    }
    
    override func setConstraints() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
        }
        address.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
            make.bottom.greaterThanOrEqualTo(contentView).offset(-5)
            //make.bottom.equalTo(contentView).offset(-10)
        }
    }
    
}


