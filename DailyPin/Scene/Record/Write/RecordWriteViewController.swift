//
//  RecordWriteViewController.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class RecordWriteViewController: BaseViewController {
    
    private let mainView = RecordWriteView()
    private let disposeBag = DisposeBag()
    
    private var record: Record?
    private var location: PlaceElement?
    
    private let saveButtonTap = PublishRelay<Void>()
    private let backButtonTap = PublishRelay<Void>()
    private var recordMode: RecordMode = .create
    
    var longPressHandler: (() -> Void)?
    
    override func loadView() {
        self.view = mainView
    }
    
    init(mode: RecordMode, record: Record?, location: PlaceElement?) {
        super.init(nibName: nil, bundle: nil)
        self.record = record
        self.location = location
        self.recordMode = mode
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
    }
    
    private func config() {
        setNavBar()
        setData()
        bindEvent()
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        longPressHandler?()
    }
    
    private func setData() {
        guard let location = location else {
            dismiss(animated: true)
            return
        }
        mainView.titleTextField.becomeFirstResponder()
        
        mainView.addressLabel.text = location.formattedAddress
        mainView.titleTextField.placeholder = location.displayName.placeName
        
        if let record = record {
            mainView.titleTextField.text = record.title
            mainView.datePickerView.date = record.date
            if let memo = record.memo {
                mainView.memoTextView.attributedText = memo.setLineSpacing()
                if !memo.isEmpty {
                    mainView.placeHolderLabel.isHidden = true
                } else {
                    mainView.placeHolderLabel.isHidden = false
                }
                
            } else {
                mainView.placeHolderLabel.isHidden = false
            }
            
            
        } else {
            mainView.datePickerView.date = Date()
        }
    }
    
}

extension RecordWriteViewController {
    private func bind() {
        
    }
    
    private func bindEvent() {
        view.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, value in
                if !owner.mainView.isEmptyText() {
                    owner.okDesctructiveAlert(title: "alert_alertEditModeTitle".localized(), message: "alert_alertEditModeMessage".localized()) {
                        owner.dismiss(animated: true)
                    } cancelHandler: {  }
                } else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension RecordWriteViewController {
    @objc private func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = mainView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 80
        mainView.scrollView.contentInset = contentInset
        mainView.scrollView.scrollIndicatorInsets = mainView.scrollView.contentInset
        
        UIView.animate(withDuration: 0.3,
                               animations: { self.view.layoutIfNeeded()},
                               completion: nil)
    }

    @objc private func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mainView.scrollView.contentInset = contentInset
    }
}

extension RecordWriteViewController {
    private func setNavBar() {
        
        switch recordMode {
        case .update:
            title = "기록 수정"
        case .create:
            title = "기록 작성"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "saveButton".localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func saveButtonTapped() {
//        saveButton.accept(true)
        
    }
}
