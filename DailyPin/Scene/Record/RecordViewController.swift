//
//  RecordViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit



final class RecordViewController: BaseViewController {
    
    private let mainView = RecordView()
    private let recordRepository = RecordRepository()
    private let placeRepository = PlaceRepository()
    private let viewModel = RecordViewModel()
    var longPressHandler: (() -> Void)?
    
    var location: PlaceElement?
    var record: Record?
    var savedPlace: Place?
    
    var mode: Mode = .read
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else {
            dismiss(animated: true)
            return
        }
        //title = location.displayName.placeName
        
        
    }
    
    
    
    override func configureUI() {
        super.configureUI()
        setData()
        configNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        mainView.textFieldDelegate = self
    }
    
    private func setData() {
        
        if let location = location {
            mainView.addressLabel.text = location.formattedAddress
            mainView.titleTextField.text = location.displayName.placeName
        }
        
        
        guard let record = record else {
            return
        }
        
        
        mainView.titleTextField.text = record.title
        mainView.dateLabel.text = DateFormatter.convertDate(date: record.date)
        mainView.memoTextView.text = record.memo
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
        
        
        guard let data = location else {
            showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) { }
            return
        }
        
        var place: Place
        
        do {
            place = try viewModel.getPlace(data)
        } catch let error {
            showOKAlert(title: "", message: error.localizedDescription) { }
            return
        }
        
        guard let title = mainView.titleTextField.text else {
            showToastMessage(message: "toast_titleIsEmpty".localized())
            return
        }
        
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showToastMessage(message: "toast_titleIsEmpty".localized())
            return
        }
        
        //---------
        if let record = record { // 기존 데이터 수정 시
            do {
                let updateRecord = Record(title: title.trimmingCharacters(in: .whitespaces), date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
                try recordRepository.updateRecord(id: record.objectID, updateRecord)
                showToastMessage(message: "toast_editComplete".localized())
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }
        } else {
            let newRecord = Record(title: title.trimmingCharacters(in: .whitespaces), date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
            do {
                try placeRepository.updateRecordList(record: newRecord, place: place)
                self.record = newRecord
                showToastMessage(message: "toast_saveComplete".localized())
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }

        }
        //--------
        
        NotificationCenter.default.post(name: Notification.Name.updateCell, object: nil)
        setNavRightButton()
        
    }
 
    
    private func deleteRecord() {
        guard let deleteRecord = record else {
            return
        }
        
        showAlertWithCancel(title: "alert_deleteTitle".localized(), message: "alert_deleteMessage".localized()) {
            do {
                try self.recordRepository.deleteItem(deleteRecord)
                self.dismiss(animated: true)
            } catch let error {
                self.showOKAlert(title: "", message: error.localizedDescription) { }
            }
            self.deletePlace()
            NotificationCenter.default.post(name: Notification.Name.updateCell, object: nil)
            
        } cancelHandler: {
            return
        }
        

        
    }
    private func deletePlace() {
        guard let location = location else { return }
        do {
            try viewModel.deletePlace(id: location.id)
        } catch {
            self.showOKAlert(title: "", message: error.localizedDescription) {  }
            return
        }
    }
    
    
    
    
}


// nav
extension RecordViewController {
    
    private func configNavigationBar() {
        
        setNavRightButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonTapped))
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
