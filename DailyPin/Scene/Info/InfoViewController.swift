//
//  InfoViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit


final class InfoViewController: BaseViewController {
    
    private let mainView = InfoView()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.updateCell, object: nil)
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        do {
            try viewModel.getRecordList()
        } catch {
            return
        }
        
        
    }
    
    override func configureUI() {
        mainView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        
        
        
    }
    
    @objc private func addButtonClicked() {

        
        let vc = RecordViewController()
        vc.location = viewModel.place.value
        vc.record = nil
        vc.mode = .edit
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
        
    }
    
    private func bindData() {
        
        viewModel.place.bind { data in
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
        
        viewModel.recordList.bind { data in
            guard data != nil else {
                return
            }
            
            self.updateSnapShot()
            
        }
        
    }
    
    
    func updateSnapShot() {
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
        
        let vc = RecordViewController()
        vc.record = item
        vc.location = viewModel.place.value
        vc.mode = .read
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        present(nav, animated: true)
        
    }
    
    
}
