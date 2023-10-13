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
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.updateCell, object: nil)
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        do {
            try viewModel.getRecordList()
            mainView.errorViewHidden(error: false)
        } catch {
            mainView.errorViewHidden(error: true)
            return
        }
        
        
    }
    
    override func configureUI() {
        mainView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        do {
            try viewModel.getRecordList()
            mainView.errorViewHidden(error: false)
        } catch {
            mainView.errorViewHidden(error: true)
            return
        }
        
        
    }
    
    @objc private func addButtonClicked() {

        
        let vc = RecordViewController()
        vc.location = viewModel.place.value
        vc.record = nil
        vc.editMode = true
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
                print("error")
            }
            
            
        }
        
        viewModel.recordList.bind { data in
           
            guard data != nil else {
                self.mainView.errorViewHidden(error: true)
                return
            }
            
            self.mainView.errorViewHidden(error: false)
            self.updateSnapShot()
            
        }
        
    }
    
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Record>()
        snapShot.appendSections([0])
        
        guard let records = viewModel.recordList.value else {
            mainView.errorViewHidden(error: true)
            return
        }
        mainView.errorViewHidden(error: false)
        snapShot.appendItems(records)
        mainView.dataSource.apply(snapShot)
    }
    
    
}

extension InfoViewController: RecordCollectionViewProtocol {
    func didSelectRecordItem(item: Record?) {
        guard let item = item else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") { }
            return
        }
        
        let vc = RecordViewController()
        vc.record = item
        vc.location = viewModel.place.value
        vc.editMode = false
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        present(nav, animated: true)
        
    }
    
    
}
