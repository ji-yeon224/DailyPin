//
//  BaseViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import SnapKit
import Toast

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
    
    func showOKAlert(title: String, message: String, handler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: LocalizableKey.okText.localized, style: .default) { _ in
            handler?()
        }
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func showAlertWithCancel(title: String, message: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: LocalizableKey.okText.localized, style: .default) { _ in
            okHandler?()
        }
        let cancel = UIAlertAction(title: LocalizableKey.cancelText.localized, style: .destructive) { _ in
            cancelHandler?()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        
        present(alert, animated: true)
    }
    
    // 확인 버튼이 빨간버튼
    func okDesctructiveAlert(title: String, message: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: LocalizableKey.okText.localized, style: .destructive) { _ in
            okHandler?()
        }
        let cancel = UIAlertAction(title: LocalizableKey.cancelText.localized, style: .cancel) { _ in
            cancelHandler?()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    
    func showToastMessage(message: String) {
        
        var style = ToastStyle()
        style.messageFont = Font.nanumBold.fontStyle
        style.backgroundColor = Constants.Color.mainColor ?? .black
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 2.0, position: .top, style: style)
        }
    }
    
}
