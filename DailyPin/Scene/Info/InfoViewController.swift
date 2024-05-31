//
//  InfoViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit
import RxSwift
import RxCocoa

final class InfoViewController: BaseViewController {
    
    let mainView = InfoView()
    private let viewModel = InfoViewModel()
    private let repository = PlaceRepository()
    
    private let requestRecordList = PublishSubject<PlaceItem?>()
    private let disposeBag = DisposeBag()
    private var placeData: PlaceItem?
    
    override func loadView() {
        self.view = mainView
    }
    
    init(placeData: PlaceItem?) {
        super.init(nibName: nil, bundle: nil)
        self.placeData = placeData
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        bindUI()
        
        requestRecordList.onNext(placeData)
        
    }
    
    deinit {
        debugPrint("infovc deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: .updateCell, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .updateCell, object: nil)
    }
    
    override func configureUI() {
        super.configureUI()
        
        if let place = placeData {
            mainView.titleLabel.text = place.name
            mainView.addressLabel.text = place.address
        }
        
        
    }
    
    private func bindData() {
        
        requestRecordList
            .bind(with: self) { owner, item in
                owner.viewModel.getRecordItems(place: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMsg
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, msg in
                if msg.count > 0 {
                    owner.showToastMessage(message: msg)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.recordSectionItme
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.collectionView.rx.items(dataSource: mainView.rxdataSource))
            .disposed(by: disposeBag)
        
        
        
    }
    
    private func bindUI() {
        mainView.addButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let vc = RecordWriteViewController(mode: .create, record: nil, location: owner.placeData)
                owner.modalTransition(vc: vc)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(Record.self)
            .bind(with: self) { owner, item in
                print(item.title)
                let vc = RecordReadViewController(record: item, location: owner.placeData)
                owner.modalTransition(vc: vc)
            }
            .disposed(by: disposeBag)
    }
    
    
}

extension InfoViewController {
    
    @objc private func getChangeNotification(notification: NSNotification) {
        requestRecordList.onNext(placeData)
        
    }
    
    private func modalTransition(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
    }
    
}

