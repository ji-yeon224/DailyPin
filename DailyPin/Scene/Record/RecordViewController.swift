//
//  RecordViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture


final class RecordViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let backButtonTap = PublishRelay<Bool>()
    private let modeType = PublishRelay<Mode>()
    private let saveButton = PublishRelay<Bool>()
    private let deleteButton = PublishRelay<Bool>()
    
    private let mainView = RecordView()
    private let viewModel = RecordViewModel()
    var longPressHandler: (() -> Void)?
    
    private var location: PlaceElement?
    private var record: Record?
    
    private var mode: Mode = .read
    
    override func loadView() {
        self.view = mainView
    }
    
    init(mode: Mode, record: Record?, location: PlaceElement?) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.record = record
        self.location = location
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = location else {
            dismiss(animated: true)
            return
        }
        viewModel.currentRecord = record
        viewModel.currentLocation = location
        
        setNavLeftButton()
        bindUI()
        bind()
        
        modeType.accept(mode)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        longPressHandler?()
    }
    
    override func configureUI() {
        super.configureUI()
        view.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
        let createRecord = PublishRelay<Record>()
        let updateRecord = PublishRelay<Record>()
        let deleteRecord = PublishRelay<Record>()
        
        let input = RecordViewModel.Input(
            createRecord: createRecord,
            updateRecord: updateRecord,
            deleteRecord: deleteRecord
        )
        let output = viewModel.transform(input: input)
        
        
        
        saveButton
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
                guard let newData = owner.getSaveRecordData() else {
                    owner.showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) { }
                    return
                }
                
                // 기존 데이터가 있는지 여부 o -> 편집 / x -> 새로 작성
                if let _ = owner.record { // update
                    updateRecord.accept(newData)
                    
                } else { // create
                    createRecord.accept(newData)
                }
            }
            .disposed(by: disposeBag)
        
        output.successCreate
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "저장", message: value) {
                    
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    
                    owner.dismiss(animated: true)
                }
                
            }
            .disposed(by: disposeBag)
        
        deleteButton
            .bind(with: self) { owner, value in
                guard let record = owner.viewModel.currentRecord else {
                    owner.showOKAlert(title: "", message: "기록을 찾을 수 없습니다.") { }
                    return
                }
                owner.showAlertWithCancel(title: "alert_deleteTitle".localized(), message: "alert_deleteMessage".localized()) {
                    deleteRecord.accept(record)
                } cancelHandler: {  }
            }
            .disposed(by: disposeBag)
        
        output.successDelete
            .bind(with: self) { owner, value in
                let (msg, refresh) = value
                
                owner.showOKAlert(title: "삭제", message: msg) {
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    owner.dismiss(animated: true)
                    
                    if refresh {
                        NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "delete"])
                    }
                    
                }
                
                
                
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "", message: value) { }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func bindUI() {
        
        modeType
            .bind(with: self) { owner, value in
                owner.setNavRightButton(mode: value)
                switch value {
                case .read:
                    owner.setData()
                    owner.mainView.setReadMode()
                case .edit:
                    owner.mainView.setPickerView()
                    owner.mainView.datePickerView.date = owner.record?.date ?? Date()
                    owner.mainView.titleTextField.becomeFirstResponder()
                    owner.setData()
                    owner.mainView.setEditMode()
                }
            }
            .disposed(by: disposeBag)
        
        mainView.datePickerView.rx.date.changed
            .bind(with: self) { owner, value in
                owner.mainView.dateLabel.text = DateFormatter.convertDate(date: value)
            }
            .disposed(by: disposeBag)
        
        mainView.memoTextView.rx.text.changed
            .bind(with: self) { owner, value in
                owner.mainView.placeHolderLabel.isHidden = value != ""
                if let text = value {
                    owner.mainView.memoTextView.attributedText = text.setLineSpacing()
                }
                owner.mainView.scrollView.updateContentView()
            }
            .disposed(by: disposeBag)
        
        mainView.titleTextField.rx.text.changed
            .withLatestFrom(mainView.titleTextField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                if value.count >= 20 {
                    owner.showToastMessage(message: "20글자 이내로 작성해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        navigationItem.leftBarButtonItem?.rx.tap
            .withLatestFrom(modeType)
            .bind(with: self) { owner, value in
                switch value {
                case .edit:
                    if !owner.mainView.isEmptyText() {
                        owner.okDesctructiveAlert(title: "alert_alertEditModeTitle".localized(), message: "alert_alertEditModeMessage".localized()) {
                            owner.dismiss(animated: true)
                        } cancelHandler: {  }
                    } else {
                        owner.dismiss(animated: true)
                    }
                case .read:
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func setData() {
        
        if let location = location {
            mainView.addressLabel.text = location.formattedAddress
            mainView.titleTextField.placeholder = location.displayName.placeName
        }
        
        
        guard let record = viewModel.currentRecord else {
            return
        }
        
        
        mainView.titleTextField.text = record.title
        mainView.titleTextField.placeholder = record.title
        mainView.dateLabel.text = DateFormatter.convertDate(date: record.date)
        
        if let memo = record.memo {
            
            mainView.memoTextView.attributedText = memo.setLineSpacing()
        }
        
        
        mainView.placeHolderLabel.isHidden = true
        
        mainView.titleLabel.text = record.title
        
    }
    
    private func getSaveRecordData() -> Record? {
        guard let location = location else {
            
            return nil
        }
        
        var title = mainView.titleTextField.text?.trimmingCharacters(in: .whitespaces) ?? location.displayName.placeName
        
        if title.isEmpty {
            title = location.displayName.placeName
        }
        
        return Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
    }
    
}

// config action
extension RecordViewController {
    
    @objc private func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = mainView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
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

// nav
extension RecordViewController {
    
    
    private func setNavLeftButton() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.xmark, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    private func setNavRightButton(mode: Mode = .read) {
        
        switch mode {
        case .edit:
            setSaveButton()
        case .read:
            setMenuButton()
        }
    }
    
    private func setSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "saveButton".localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    @objc private func saveButtonTapped() {
        saveButton.accept(true)
        
    }
    
    private func setMenuButton() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: "editButton".localized()) { action in
            self.mode = .edit
            self.modeType.accept(self.mode)
            
        }
        let deleteAction = UIAction(title: "deleteButton".localized()) { action in
            self.deleteButton.accept(true)
            
        }
        menuItems.append(editAction)
        menuItems.append(deleteAction)
        
        var menu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image:  Constants.Image.menuButton, primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
 
    
    
}


