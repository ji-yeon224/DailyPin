//
//  SearchCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/30.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var title = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.font = .systemFont(ofSize: 15, weight: .bold)
        return view
    }()
    private var image = {
        var view = UIImageView()
        view.image = UIImage(systemName: "mappin.circle.fill")
        view.backgroundColor = Constants.Color.background
        view.tintColor = Constants.Color.mainColor
        
        return view
    }()
    
    var address = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = Constants.Color.basicText
        return view
    }()
    
    override func configureUI() {
        contentView.addSubview(title)
        contentView.addSubview(image)
        contentView.addSubview(address)
        
    }
    
    override func setConstraints() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.verticalEdges.equalTo(contentView).offset(20)
            make.height.equalTo(image.snp.width).multipliedBy(1.0)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
            make.height.equalTo(contentView).multipliedBy(0.5)
        }
        address.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(-10)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(20)
        }
    }
    
}


