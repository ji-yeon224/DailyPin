//
//  InfoView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit

final class InfoView: BaseView {
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    
    override func configureUI() {
        super.configureUI()
        addSubview(titleLabel)
    }
    
    override func setConstraints() {
        titleLabel.text = "title label"
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(16)
            make.height.equalTo(30)
            
        }
    }
    
}
