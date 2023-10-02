//
//  InfoView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit

final class InfoView: BaseView {
    
    let uiView = UIView()
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 23)
        return view
    }()
    
    var addressLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subTextColor
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 13)
        return view
    }()

    let addButton = AddButton()

//    // 저장된 목록 보여주기
//    let collectionView = {
//        let view = UICollectionView()
//
//        return view
//    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(uiView)
        uiView.addSubview(titleLabel)
        uiView.addSubview(addButton)
        uiView.addSubview(addressLabel)
    }
    
    override func setConstraints() {
        uiView.backgroundColor = Constants.Color.background
        uiView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(uiView).offset(35)
            make.leading.equalTo(uiView).inset(16)
            make.height.equalTo(40)
            
        }
        
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(uiView).inset(35)
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.width.equalTo(uiView.snp.width).multipliedBy(0.08)
            make.height.equalTo(addButton.snp.width).multipliedBy(1)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(uiView).inset(16)
            make.height.equalTo(50)
        }
        
        
    }
    
}
