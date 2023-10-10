//
//  CalendarView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import Foundation
import UIKit

final class CalendarView: BaseView {
    
    let label = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.text = "label"
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
    }
    
}
