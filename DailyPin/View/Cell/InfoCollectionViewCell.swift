//
//  InfoCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/07.
//

import UIKit

final class InfoCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "InfoCollectionViewCell"
    
    private lazy var stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 8
        
        return view
    }()
    private let barImg = UIImageView().then {
        $0.image = Constants.Image.recordSeparator
        $0.contentMode = .scaleToFill
    }
    
    var titleLabel = BasicTextLabel(style: .title2).then {
        $0.textAlignment = .left
    }
    
    
    var address = BasicTextLabel(style: .body)
    
    var dateLabel = BasicTextLabel(style: .caption, color: Constants.Color.subTextColor)
    
    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = Constants.Color.background
        contentView.layer.cornerRadius = 8
        
        [barImg, stackView].forEach {
            contentView.addSubview($0)
        }
        [titleLabel, address, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        
        barImg.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(0)
            make.leading.equalTo(contentView).offset(4)
            make.width.equalTo(6)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(10)
            make.leading.equalTo(barImg.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-20)
        }

    }
    
    
}


