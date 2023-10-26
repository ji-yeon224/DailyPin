//
//  RecordViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit



final class RecordViewController: BaseViewController {
    
    private let mainView = RecordView()
    private let viewModel = RecordViewModel()
    var longPressHandler: (() -> Void)?
    
    var location: PlaceElement?
    var record: Record?
    
    var mode: Mode = .read
    
    override func loadView() {
        self.view = mainView
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = location else {
            dismiss(animated: true)
            return
        }
        viewModel.currentRecord = record
        viewModel.currentLocation = location
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func bindData() {
        viewModel.errorDescription.bind { data in
            if let message = data {
                self.showOKAlert(title: "", message: message) { }
            }
            
        }
    }
    
    
    
    override func configureUI() {
        super.configureUI()
        
        configNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        mainView.textFieldDelegate = self
        
        

    }
    
    
    @objc func keyboardWillShow(notification:NSNotification) {

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

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mainView.scrollView.contentInset = contentInset
    }
    
    
    private func setData() {
        
        if let location = viewModel.currentLocation {
            mainView.addressLabel.text = location.formattedAddress
            mainView.titleTextField.placeholder = location.displayName.placeName
        }
        
        
        guard let record = viewModel.currentRecord else {
            return
        }
        
        
        mainView.titleTextField.text = record.title
        mainView.titleTextField.placeholder = record.title
        mainView.dateLabel.text = DateFormatter.convertDate(date: record.date)
        mainView.setLineSpacing(text: record.memo)
        //mainView.memoTextView.text = record.memo
        mainView.placeHolderLabel.isHidden = true
        mainView.setReadMode()
        mainView.titleLabel.text = record.title
        
        
    }
    
    @objc private func tappedView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        
        mode = .read
        saveRecord()
        dismiss(animated: true)
        longPressHandler?()
        
    }
    
    
    private func saveRecord() {
        
        
        guard let _ = viewModel.currentLocation else {
            showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) { }
            return
        }
        
        guard let location = viewModel.currentLocation else { return }
        
        var title = mainView.titleTextField.text?.trimmingCharacters(in: .whitespaces) ?? location.displayName.placeName
        
        if title.isEmpty {
            title = location.displayName.placeName
        }
        
        if let _ = viewModel.currentRecord {
            let updateRecord = Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
            viewModel.updateRecord(updateRecord)
        } else {
            let newRecord = Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
            viewModel.createRecord(newRecord)
        }
        
        NotificationCenter.default.post(name: Notification.Name.updateCell, object: nil)
        setNavRightButton()
        
    }
 
    
    private func deleteRecord() {
        guard let deleteRecord = record else {
            return
        }
        
        showAlertWithCancel(title: "alert_deleteTitle".localized(), message: "alert_deleteMessage".localized()) {

            do {
                try self.viewModel.deleteRecord(record: deleteRecord)
                self.dismiss(animated: true)
            } catch {
                self.viewModel.errorDescription.value = error.localizedDescription
                return
            }
            self.deletePlace()
        } cancelHandler: {
            return
        }
        
    }
    private func deletePlace() {
        guard let location = viewModel.currentLocation else { return }
        viewModel.deletePlace(id: location.id)
        
    }
    
}


// nav
extension RecordViewController {
    
    private func configNavigationBar() {
        
        setNavRightButton()
        setNavLeftButton()
        
    }
    
    private func setNavLeftButton() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.xmark, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    private func setNavRightButton() {
        
        switch mode {
        case .edit:
            setSaveButton()
            mainView.setEditMode()
        case .read:
            setMenuButton()
            mainView.setReadMode()
            setData()
        }
    }
    
    private func setSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "saveButton".localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    private func setMenuButton() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: "editButton".localized()) { action in
            self.mode = .edit
            self.mainView.setPickerView()
            self.mainView.datePickerView.date = self.record?.date ?? Date()
            self.setNavRightButton()
            self.mainView.titleTextField.becomeFirstResponder()
        }
        let deleteAction = UIAction(title: "deleteButton".localized()) { action in
            self.deleteRecord()
            
            
        }
        menuItems.append(editAction)
        menuItems.append(deleteAction)
        
        var menu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image:  Constants.Image.menuButton, primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    
    @objc private func backButtonTapped() {
        
        switch mode {
        case .edit:
            if !mainView.isEmptyText() {
                okDesctructiveAlert(title: "alert_alertEditModeTitle".localized(), message: "alert_alertEditModeMessage".localized()) {
                    
                    self.dismiss(animated: true)
                } cancelHandler: {
                    
                }
            } else {
                dismiss(animated: true)
            }
            
        case .read:
            dismiss(animated: true)
            
        }
        
    }
    
}

extension RecordViewController: TextFieldProtocol {
    func shouldChangeCharactersIn() {
        showToastMessage(message: "20글자 이내로 작성해주세요.")
    }
    
    
    
}
