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
    
    var location: PlaceElement?
    var record: Record?
    var savedPlace: Place?
    
    var editMode: Bool = false // 읽기모드
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else {
            dismiss(animated: true)
            return
        }
        title = location.displayName.placeName
        
        
    }
    
    
    
    override func configureUI() {
        super.configureUI()
        setData()
        configNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func setData() {
        
        guard let record = record else {
            return
        }
        
        
        mainView.titleTextField.text = record.title
        mainView.dateLabel.text = DateFormatter.convertDate(date: record.date)
        mainView.memoTextView.text = record.memo
        mainView.placeHolderLabel.isHidden = true
        
        
    }
    
    @objc private func tappedView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        
        editMode.toggle()
        setNavRightButton()
        saveRecord()
       
    }
    
    private func saveRecord() {
        
        guard let data = location else {
            showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) { }
            return
        }
        var place: Place
        if placeRepository.isExistPlace(id: data.id) {
            do {
                place = try placeRepository.searchItemByID(data.id)
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }
        } else {
            do {
                place = try savePlace()
                
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }
            
        }
        
        guard let title = mainView.titleTextField.text else {
            showToastMessage(message: "제목을 입력해주세요!")
            return
        }
        
        if let record = record { // 기존 데이터 수정 시
            do {
                let updateRecord = Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
                try recordRepository.updateRecord(id: record.objectID, updateRecord)
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }
        } else {
            let newRecord = Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
            do {
                try placeRepository.updateRecordList(record: newRecord, place: place)
            } catch let error {
                showOKAlert(title: "", message: error.localizedDescription) { }
                return
            }
        }
        
        
        
    }
    
    private func deleteRecord() {
        guard let deleteRecord = record else {
            return
        }
        
        showAlertWithCancel(title: "삭제하기", message: "기록을 정말 삭제하시겠습니까?") {
            do {
                try self.recordRepository.deleteItem(deleteRecord)
                self.dismiss(animated: true)
            } catch let error {
                self.showOKAlert(title: "", message: error.localizedDescription) { }
            }
            self.deletePlace()
            
        } cancelHandler: {
            return
        }
        

        
    }
    private func deletePlace() {
        guard let location = location else { return }
        if placeRepository.getRecordListCount(id: location.id) == 0 {
            
            var deletePlace: Place
            do {
                deletePlace = try placeRepository.searchItemByID(location.id)
                
            } catch let error {
                self.showOKAlert(title: "", message: error.localizedDescription) {  }
                return
            }
            
            do {
                try placeRepository.deleteItem(deletePlace)
            } catch let error {
                self.showOKAlert(title: "", message: error.localizedDescription) {  }
                return
            }
            
            NotificationCenter.default.post(name: Notification.Name.databaseChange, object: nil, userInfo: ["changeType": "delete"])
        }
    }
    
    private func savePlace() throws -> Place {
        guard let data = location else {
            
            throw InvalidError.noExistData
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        
        do {
            try placeRepository.createItem(place)
            showToastMessage(message: "저장 완료!")
            NotificationCenter.default.post(name: Notification.Name.databaseChange, object: nil, userInfo: ["changeType": "save"])
            return place
        } catch {
            throw DataBaseError.createError
        }
    }
    
    
    
}


// nav
extension RecordViewController {
    
    private func configNavigationBar() {
        
        setNavRightButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    private func setNavRightButton() {
        if editMode { // 편집모드
            setSaveButton()
            mainView.setEditMode()
            
        } else { // 저장 버튼 클릭
            
            setMenuButton()
            mainView.setReadMode()
            
        }
    }
    
    private func setSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Mode.save.rawValue.localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    private func setMenuButton() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: Mode.edit.rawValue.localized()) { action in
            self.editMode = true
            self.mainView.setPickerView()
            self.mainView.datePickerView.date = self.record?.date ?? Date()
            self.setNavRightButton()
        }
        let deleteAction = UIAction(title: Mode.delete.rawValue.localized()) { action in
            self.deleteRecord()
            
            
        }
        menuItems.append(editAction)
        menuItems.append(deleteAction)
        
        var menu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image:  UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
}
