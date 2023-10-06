//
//  RecordViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit



class RecordViewController: BaseViewController {
    
    private let mainView = RecordView()
    var location: PlaceElement?
    
    var editMode: Bool = false // 읽기모드
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = location?.displayName.placeName
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
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
        
    }
    
    private func setNavRightButton() {
        if editMode { // 편집모드
            setSaveButton()
        } else {
            setMenuButton()
        }
    }
    
    private func setSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Mode.save.rawValue.localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    private func setMenuButton() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: Mode.edit.rawValue.localized()) { action in
            print("edit")
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
