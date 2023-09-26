//
//  BaseViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHirachy()
        setConstraints()
    }
    
    func configureHirachy() {
        view.backgroundColor = Constants.Color.background
    }
    
    func setConstraints() {
        
    }
    
}
