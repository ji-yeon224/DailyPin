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
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = Constants.Color.background
    }
    
    func setConstraints() {
        
    }
    
    func showAlertMessage(title: String, message: String, handler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
