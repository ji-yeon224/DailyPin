//
//  RecordReadViewController.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit
import RxSwift
import RxCocoa



final class RecordReadViewController: BaseViewController {
    
    private let mainView = RecordReadView()
    private let viewModel = RecordReadViewModel()
    
    private var record: Record?
    private var location: PlaceItem?
    var disposeBag = DisposeBag()
    private var editButtonTap = PublishRelay<Void>()
    private var deleteButtonTap = PublishRelay<Void>()
    
    private var requestDeleteRecord = PublishRelay<(Record, PlaceItem)>()
    
    override func loadView() {
        self.view = mainView
    }
    
    init(record: Record?, location: PlaceItem?) {
        super.init(nibName: nil, bundle: nil)
        self.record = record
        self.location = location
    }
    
    deinit {
        debugPrint("readvc deinit")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        configData()
        bind()
        bindEvent()
    }
    
    
    private func configData() {
        guard let record = record, let location = location else {
            dismiss(animated: true)
            return
        }
        mainView.setRecordData(data: record, address: location.address)
        
        
    }
    
    
    
    
}

extension RecordReadViewController {
    
    private func bind() {
        
        let input = RecordReadViewModel.Input(deleteRecord: requestDeleteRecord)
        let output = viewModel.transform(input: input)
        
        output.msg
            .asDriver(onErrorJustReturn: "")
            .filter { $0.count > 0}
            .drive(with: self) { owner, value in
                owner.showToastMessage(message: value)
            }
            .disposed(by: disposeBag)
        
        output.successDelete
            .bind(with: self) { owner, value in
                let (msg, refresh) = value
                owner.showOKAlert(title: "deleteButton".localized(), message: msg) {
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    owner.dismiss(animated: true)
                    
                    if refresh {
                        NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo:  [NotificationKey.changeType: ChangeType.delete])
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func bindEvent() {
        let refreshRecord = PublishRelay<(Record, String)>()
        navigationItem.leftBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        editButtonTap
            .bind(with: self) { owner, _ in
                //수정 뷰 이동
                if let record = owner.record, let location = owner.location {
                    let vc = RecordWriteViewController(mode: .update, record: record, location: location)
                    vc.updateRecord = { data in
                        refreshRecord.accept((data, location.address))
                    }
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalTransitionStyle = .crossDissolve
                    owner.present(nav, animated: true)
//                    owner.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            .disposed(by: disposeBag)
        
        refreshRecord
            .bind(with: self) { owner, value in
                owner.mainView.setRecordData(data: value.0, address: value.1)
            }
            .disposed(by: disposeBag)
        
        deleteButtonTap
            .bind(with: self) { owner, _ in
                guard let record = owner.record, let location = owner.location else {
                    owner.showOKAlert(title: "", message: "toase_recordLoadError".localized()) { }
                    return
                }
                owner.showAlertWithCancel(title: "alert_deleteTitle".localized(), message: "alert_deleteMessage".localized()) {
                    owner.requestDeleteRecord.accept((record, location))
                } cancelHandler: {  }
                
            }
            .disposed(by: disposeBag)
    }
}

extension RecordReadViewController {
    private func setNavBar() {
        title = "기록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.xmark, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        setMenuButton()
    }
    
    private func setMenuButton() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: "editButton".localized()) { action in
//            self.mode = .edit
//            self.modeType.accept(self.mode)
            self.editButtonTap.accept(())
            
        }
        let deleteAction = UIAction(title: "deleteButton".localized()) { action in
//            self.deleteButton.accept(true)
            self.deleteButtonTap.accept(())
            
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
