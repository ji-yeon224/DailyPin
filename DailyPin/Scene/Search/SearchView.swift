//
//  SearchView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit

final class SearchView: BaseView {
    
    let label = UILabel()
    
    override func configureUI() {
        super.configureUI()
        addSubview(label)
    }
    
    override func setConstraints() {
        label.text = "hello"
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
}
