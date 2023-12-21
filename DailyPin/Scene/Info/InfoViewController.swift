//
//  InfoViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit


final class InfoViewController: BaseViewController {
    
    let mainView = InfoView()
    let viewModel = InfoViewModel()
    private let repository = PlaceRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionViewDelegate = self
        bindData()
        
        do {
            try viewModel.getRecordList()
        } catch {
            return
        }
        
        
    }
    
    deinit {
        print("infovc deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: .updateCell, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .updateCell, object: nil)
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        do {
            try viewModel.getRecordList()
        } catch {
            return
        }
        
        
    }
    
    override func configureUI() {
        super.configureUI()
        mainView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        
        
        
    }
    
    @objc private func addButtonClicked() {

        
        let vc = RecordViewController(mode: .edit, record: nil, location: viewModel.place.value)
//        vc.location = viewModel.place.value
//        vc.record = nil
//        vc.mode = .edit
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
        
    }
    
    private func bindData() {
        
        viewModel.place.bind { [weak self] data in
            guard let self = self else { return }
            guard let place = data else {
                self.showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) {
                    self.dismiss(animated: true)
                }
                
                return
            }
            self.mainView.titleLabel.text = place.displayName.placeName
            self.mainView.addressLabel.text = place.formattedAddress
            
            do {
                try self.viewModel.getRecordList()
            } catch {
                self.showToastMessage(message: "toase_recordLoadError".localized())
            }
            
            
        }
        
        viewModel.recordList.bind { [weak self] data in
            guard data != nil else {
                return
            }
            
            self?.updateSnapShot()
            
        }
        
    }
    
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Record>()
        snapShot.appendSections([0])
        
        guard let records = viewModel.recordList.value else {
            return
        }
        
        snapShot.appendItems(records)
        mainView.dataSource.apply(snapShot)
    }
    
    
}

extension InfoViewController: RecordCollectionViewProtocol {
    func didSelectRecordItem(item: Record?) {
        guard let item = item else {
            showOKAlert(title: "", message: "alert_dateLoadError".localized()) { }
            return
        }
        
        let vc = RecordViewController(mode: .read, record: item, location: viewModel.place.value)
//        vc.record = item
//        vc.location = viewModel.place.value
//        vc.mode = .read
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        present(nav, animated: true)
        
    }
    
    
}
