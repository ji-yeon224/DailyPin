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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //viewModel.recordList.value = nil
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
        }
        
        viewModel.recordList.bind { data in
            guard let records = data else {
                self.mainView.configureHidden(collView: true)
                return
            }
            
            
            self.mainView.configureHidden(collView: false)
            self.updateSnapShot()
            
        }
        
    }
    
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Record>()
        snapShot.appendSections([0])
        
        guard let records = viewModel.recordList.value else {
            mainView.configureHidden(collView: true)
            return
        }
        mainView.configureHidden(collView: false)
        snapShot.appendItems(Array(records))
        mainView.dataSource.apply(snapShot)
    }
    
    
}

extension InfoViewController: InfoCollectionViewProtocol {
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
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        present(nav, animated: true)
        
    }
    
    
}
