//
//  MainMapView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit


final class MainMapView: BaseView {
    
    let label = UILabel()
    
    override func configureUI() {
        addSubview(label)
    }
    
    override func setConstraints() {
        label.text = "hello"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            
        }
    }
    
}
