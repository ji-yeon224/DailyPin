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
    private var location: PlaceElement?
    var disposeBag = DisposeBag()
    private var editButtonTap = PublishRelay<Void>()
    private var deleteButtonTap = PublishRelay<Void>()
    
    private var requestDeleteRecord = PublishRelay<(Record, PlaceElement)>()
    
    override func loadView() {
        self.view = mainView
    }
    
    init(record: Record?, location: PlaceElement?) {
        super.init(nibName: nil, bundle: nil)
        self.record = record
        self.location = location
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
        mainView.addressLabel.text = location.formattedAddress
        mainView.titleLabel.text = record.title
        mainView.dateLabel.text = DateFormatter.convertDate(date: record.date)
        if let memo = record.memo {
            mainView.memoTextView.attributedText = memo.setLineSpacing()
        }
        
        
        
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
                owner.showOKAlert(title: "삭제", message: msg) {
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    owner.dismiss(animated: true)
                    
                    if refresh {
                        NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "delete"])
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func bindEvent() {
        navigationItem.leftBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        editButtonTap
            .bind(with: self) { owner, _ in
                //수정 뷰 이동
            }
            .disposed(by: disposeBag)
        deleteButtonTap
            .bind(with: self) { owner, _ in
                guard let record = owner.record, let location = owner.location else {
                    owner.showOKAlert(title: "", message: "기록을 찾을 수 없습니다.") { }
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
