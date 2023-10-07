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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func bindData() {
        
        
        
    }
    
    
    
    override func configureUI() {
        super.configureUI()
        setNavRightButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
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
        
        let record = Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
        
        do {
            
            try placeRepository.updateRecordList(record: record, place: place)
        } catch let error {
            showOKAlert(title: "", message: error.localizedDescription) { }
            return
        }
        
    }
    
    private func savePlace() throws -> Place {
        guard let data = location else {
            
            throw InvalidError.noExistData
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        
        do {
            try placeRepository.createItem(place)
            showToastMessage(message: "저장 성공")
            return place
        } catch {
            throw DataBaseError.createError
        }
    }
    
    
    
}


// nav
extension RecordViewController {
    private func setNavRightButton() {
        if editMode { // 편집모드
            setSaveButton()
            mainView.setPickerView()
            mainView.titleTextField.isUserInteractionEnabled = true
            mainView.memoTextView.isEditable = true
            
        } else { // 저장 버튼 클릭
            
            setMenuButton()
            mainView.setDateLabel()
            mainView.titleTextField.isUserInteractionEnabled = false
            mainView.memoTextView.isEditable = false
            
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
            self.setNavRightButton()
        }
        let deleteAction = UIAction(title: Mode.delete.rawValue.localized()) { action in
            print("delete")
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
